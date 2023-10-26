part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductAddButtonLoading extends ProductState {}

class ProductAddError extends ProductState {
  final AppExceptions exception;

  const ProductAddError(this.exception);

  @override
  List<Object> get props => [exception];
}

class ProductAddSuccess extends ProductState {}
