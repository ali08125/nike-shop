import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/ui/product/bloc/product_bloc.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository productRepository;
  ProductListBloc({required this.productRepository})
      : super(ProductListLoading()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductListStarted) {
        emit(ProductListLoading());
        try {
          final products = await productRepository.getAll(event.sort);
          emit(ProductListSuccess(products, event.sort));
        } catch (e) {
          emit(ProductListError(AppExceptions()));
        }
      }
    });
  }
}
