part of 'payment_receipt_bloc.dart';

abstract class PaymentReceiptState extends Equatable {
  const PaymentReceiptState();

  @override
  List<Object> get props => [];
}

class PaymentReceipLoading extends PaymentReceiptState {}

class PaymentReceiptSuccess extends PaymentReceiptState {
  final PaymentReceiptData data;

  const PaymentReceiptSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class PaymentReceiptError extends PaymentReceiptState {
  final AppExceptions exceptions;

  const PaymentReceiptError(this.exceptions);

  @override
  List<Object> get props => [exceptions];
}
