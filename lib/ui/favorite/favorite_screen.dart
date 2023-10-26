import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/data/product.dart';
import 'package:nike/ui/product/details.dart';
import 'package:nike/ui/widgets/empty_state.dart';
import 'package:nike/ui/widgets/image.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('لیست علاقه مندی ها'),
        ),
        body: ValueListenableBuilder<Box<Product>>(
          valueListenable: favoriteManager.listenable,
          builder: (BuildContext context, Box<Product> value, Widget? child) {
            return value.values.length != 0
                ? ListView.builder(
                    itemCount: value.values.toList().length,
                    itemBuilder: (context, index) {
                      final product = value.values.toList()[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDatailScreen(
                              product: product,
                            ),
                          ));
                        },
                        onLongPress: () {
                          favoriteManager.deleteFavorite(product.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 110,
                                  height: 110,
                                  child:
                                      CashedImage(imageUrl: product.imageUrl)),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        product.previousPrice.withPriceLabel(),
                                        style: themeData.textTheme.bodySmall!
                                            .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(product.price.withPriceLabel())
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : EmptyView(
                    message: 'کالایی به لیست علاقه مندی خود اضافه نکرده اید',
                    image: Center(
                      child: SizedBox(
                          height: 200,
                          width: 200,
                          child: SvgPicture.asset('assets/img/no_data.svg')),
                    ));
          },
        ));
  }
}
