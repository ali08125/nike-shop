import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/favorite_manager.dart';

import '../../data/product.dart';
import '../widgets/image.dart';
import 'details.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ProductDatailScreen(
                      product: widget.product,
                    )),
          ),
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 176,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.93,
                      child: CashedImage(
                        imageUrl: widget.product.imageUrl,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 16,
                      child: InkWell(
                        onTap: () {
                          if (favoriteManager.isFavorite(widget.product.id)) {
                            favoriteManager.deleteFavorite(widget.product.id);
                          } else {
                            favoriteManager.addFavorite(widget.product);
                          }
                          setState(() {});
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: ValueListenableBuilder(
                            valueListenable: favoriteManager.listenable,
                            builder: (BuildContext context, Box<Product> value,
                                Widget? child) {
                              return Icon(
                                favoriteManager.isFavorite(widget.product.id)
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                size: 20,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.product.previousPrice.withPriceLabel(),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(widget.product.price.withPriceLabel()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
