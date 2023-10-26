import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/create_order_result.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/repo/order_repository.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderRepository orderRepository;
  ShippingBloc(this.orderRepository) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingSubmit) {
        try {
          emit(ShippingLoading());
          final result = await orderRepository.create(event.params);
          emit(ShippingSuccess(result));
        } catch (e) {
          emit(ShippingError(AppExceptions()));
        }
      }
    });
  }
}
