import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/repo/order_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/receipt/bloc/payment_receipt_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;
  const PaymentReceiptScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('رسید پرداخت')),
      body: BlocProvider(
        create: (context) => PaymentReceiptBloc(orderRepository)
          ..add(PaymentReceiptStarted(orderId)),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state is PaymentReceiptSuccess) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.1), width: 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Text(
                          state.data.purchaseSuccess
                              ? 'پرداخت با موفقیت انجام شد'
                              : 'پرداخت ناموفق',
                          style: themeData.textTheme.labelLarge!
                              .copyWith(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('وضعیت سفارش',
                                style: TextStyle(
                                    color:
                                        LightThemeColors.secondaryTextColor)),
                            Text(state.data.paymentStatus,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16))
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Divider(
                          height: 1,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'مبلغ',
                              style: TextStyle(
                                  color: LightThemeColors.secondaryTextColor),
                            ),
                            Text(
                              state.data.payablePrice.withPriceLabel(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('بازگشت به صفحه اصلی'))
                ],
              );
            } else if (state is PaymentReceipLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PaymentReceiptError) {
              return Center(
                child: Text(state.exceptions.message),
              );
            } else {
              return const Center(
                child: Text('state not supported!!!'),
              );
            }
          },
        ),
      ),
    );
  }
}
