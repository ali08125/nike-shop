part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListLoading extends ProductListState {}

class ProductListSuccess extends ProductListState {
  final List<Product> products;
  final int sort;

  const ProductListSuccess(this.products, this.sort);

  @override
  List<Object> get props => [products];
}

class ProductListError extends ProductListState {
  final AppExceptions exceptions;

  const ProductListError(this.exceptions);

  @override
  List<Object> get props => [exceptions];
}
