part of 'cart_bloc.dart';

abstract class CartState {
  const CartState();

}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartResponse response;

  const CartSuccess(this.response);

 
}

class CartEmpty extends CartState{}

class CartError extends CartState {
  final AppExceptions exception;

  const CartError(this.exception);

}

class CartAuthRequired extends CartState{}