import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/payment_receipt.dart';
import 'package:nike/data/repo/order_repository.dart';

part 'payment_receipt_event.dart';
part 'payment_receipt_state.dart';

class PaymentReceiptBloc
    extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository orderRepository;
  PaymentReceiptBloc(this.orderRepository) : super(PaymentReceipLoading()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if (event is PaymentReceiptStarted) {
        try {
          emit(PaymentReceipLoading());
          final data = await orderRepository.getPaymentReceipt(event.orderId);
          emit(PaymentReceiptSuccess(data));
        } catch (e) {
          emit(PaymentReceiptError(AppExceptions()));
        }
      }
    });
  }
}
