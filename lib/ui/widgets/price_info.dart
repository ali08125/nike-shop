import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo(
      {super.key,
      required this.totalPrice,
      required this.payablePrice,
      required this.shippingCost});
  final int totalPrice;
  final int payablePrice;
  final int shippingCost;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'جزئیات خرید',
          style: themeData.textTheme.titleMedium,
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          // margin: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: themeData.colorScheme.surface,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ]),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ کل خرید'),
                    Text(totalPrice.withPriceLabel()),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('هزینه ارسال'),
                    Text(shippingCost.withPriceLabel()),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'مبلغ قابل پرداخت',
                    ),
                    RichText(
                      text: TextSpan(
                          text: payablePrice
                              .toString()
                              .seRagham()
                              .toPersianDigit(),
                          style: themeData.textTheme.titleLarge!
                              .copyWith(fontSize: 16),
                          children: [
                            TextSpan(
                                text: ' تومان',
                                style: themeData.textTheme.bodyMedium!.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ))
                          ]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
