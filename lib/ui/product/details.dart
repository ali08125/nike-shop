import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/product/bloc/product_bloc.dart';
import 'package:nike/ui/product/comment/comment_list.dart';
import 'package:nike/ui/widgets/image.dart';

class ProductDatailScreen extends StatefulWidget {
  final Product product;

  const ProductDatailScreen({super.key, required this.product});

  @override
  State<ProductDatailScreen> createState() => _ProductDatailScreenState();
}

class _ProductDatailScreenState extends State<ProductDatailScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  StreamSubscription<ProductState>? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          streamSubscription = bloc.stream.listen((state) {
            if (state is ProductAddSuccess) {
              _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('با موفقیت به سبد خرید اضافه شد')));
            } else if (state is ProductAddError) {
              _scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButton: SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    return FloatingActionButton.extended(
                        onPressed: () {
                          BlocProvider.of<ProductBloc>(context)
                              .add(CartAddButtonClick(widget.product.id));
                        },
                        label: state is ProductAddButtonLoading
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                            : const Text('افزودن به سبد خرید'));
                  },
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: CustomScrollView(
              physics: defaultScroll,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace: CashedImage(imageUrl: widget.product.imageUrl),
                  foregroundColor: LightThemeColors.secondaryColor,
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.title,
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.product.previousPrice.withPriceLabel(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        decoration: TextDecoration.lineThrough),
                              ),
                              Text(widget.product.price.withPriceLabel()),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نظرات کاربران',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextButton(
                              onPressed: () {}, child: const Text('ثبت نظر'))
                        ],
                      ),
                    ]),
                  ),
                ),
                CommentList(productId: widget.product.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
