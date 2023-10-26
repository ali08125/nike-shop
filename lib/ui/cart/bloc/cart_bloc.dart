import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/cart_response.dart';
import 'package:nike/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;
  CartBloc(this.cartRepository) : super(CartInitial()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit, event.isRefreshing);
        }
      } else if (event is CartAuthChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else if (state is CartAuthRequired) {
          await loadCartItems(emit, false);
        }
      } else if (event is CartDeleteButtonClicked) {
        
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final index = successState.response.cartItems
                .indexWhere((element) => element.id == event.cartItemId);
            successState.response.cartItems[index].deleteButtonLoading = true;
            emit(CartSuccess(successState.response));
          }
          await cartRepository.delete(event.cartItemId);
          await cartRepository.count();

          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.response.cartItems
                .removeWhere((element) => element.id == event.cartItemId);

            if (successState.response.cartItems.isNotEmpty) {
              emit(calculatePriceInfo(successState.response));
            } else {
              emit(CartEmpty());
            }
          }
        } catch (e) {}
      }
    });
  }

  Future<void> loadCartItems(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoading());
      }
      final response = await cartRepository.getAll();
      if (response.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(response));
      }
    } catch (e) {
      emit(CartError(AppExceptions()));
    }
  }

  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;

    cartResponse.cartItems.forEach((cartItem) {
      totalPrice += cartItem.count * cartItem.product.previousPrice;
      payablePrice += cartItem.count * cartItem.product.price;
    });

    shippingCost = payablePrice >= 250000 ? 0 : 30000;

    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;

    return CartSuccess(cartResponse);
  }
}
