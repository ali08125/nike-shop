import 'package:flutter/material.dart';

import '../../common/utils.dart';
import '../../data/product.dart';
import '../product/product_item.dart';

class HorizontalProductList extends StatelessWidget {
  final List<Product> state;
  final String title;
  final Function() onTap;
  const HorizontalProductList({
    super.key,
    required this.state,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                  onPressed: onTap,
                  child: Text(
                    'نمایش همه',
                    style: Theme.of(context).textTheme.labelLarge,
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 290,
          // width: double.infinity,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              physics: defaultScroll,
              padding: const EdgeInsets.only(left: 4, right: 4),
              scrollDirection: Axis.horizontal,
              itemCount: state.length,
              itemBuilder: (context, index) {
                return ProductItem(product: state[index]);
              },
            ),
          ),
        )
      ],
    );
  }
}
