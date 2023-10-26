import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/cart_item.dart';
import 'package:nike/ui/widgets/image.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {super.key,
  
      required this.onDeleteButtonClicked, required this.item});
  final CartItemEntity item;
  final GestureTapCallback onDeleteButtonClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: CashedImage(imageUrl: item.product.imageUrl)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4, right: 8),
                      child: Text(
                        item.product.title,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 8, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'تعداد',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 12),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(CupertinoIcons.plus_square)),
                          Text(
                            item.count.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontSize: 16, color: Colors.black),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(CupertinoIcons.minus_square)),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        item.product.previousPrice.withPriceLabel(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(item.product.price.withPriceLabel())
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            item.deleteButtonLoading
                ? const SizedBox(
                  height: 48,
                  child: CupertinoActivityIndicator())
                : TextButton(
                    onPressed: onDeleteButtonClicked, child: const Text('حذف از سبد خرید'))
          ],
        ),
      ),
    );
  }
}
