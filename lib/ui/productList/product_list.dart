import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/ui/product/product_item.dart';
import 'package:nike/ui/productList/bloc/product_list_bloc.dart';
import 'package:nike/ui/widgets/error_screen.dart';
import 'package:nike/ui/widgets/product_sort.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;

  const ProductListScreen({super.key, required this.sort});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType { grid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.grid;

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('کفش های ورزشی'),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc = ProductListBloc(productRepository: productRepository)
            ..add(ProductListStarted(widget.sort));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              return Column(
                children: [
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: themeData.dividerColor, width: 1)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20)
                        ]),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24))),
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 32, 16, 0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'انتخاب مرتب سازی',
                                            style: themeData
                                                .textTheme.labelLarge!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                          ),
                                          Expanded(
                                              child: ListView.builder(
                                            itemCount: ProductSort.names.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  bloc!.add(ProductListStarted(
                                                      index));
                                                  Navigator.of(context).pop();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        ProductSort
                                                            .names[index],
                                                        style: themeData
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      if (index == state.sort)
                                                        Icon(
                                                          CupertinoIcons
                                                              .check_mark_circled_solid,
                                                          color: themeData
                                                              .colorScheme
                                                              .primary,
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(
                                    CupertinoIcons.sort_down,
                                    size: 28,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'مرتب سازی',
                                      style: themeData.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      ProductSort.names[state.sort],
                                      style: themeData.textTheme.bodySmall,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            width: 1,
                            color: themeData.dividerColor,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  viewType = viewType == ViewType.list
                                      ? ViewType.grid
                                      : ViewType.list;
                                });
                              },
                              icon: const Icon(
                                CupertinoIcons.square_grid_2x2,
                                size: 30,
                              )),
                          const SizedBox(
                            width: 8,
                          )
                        ]),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: state.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.65,
                          crossAxisCount: viewType == ViewType.grid ? 2 : 1),
                      itemBuilder: (context, index) {
                        return ProductItem(product: state.products[index]);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is ProductListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProductListError) {
              return ErrorScreen(onPressed: () {}, exception: AppExceptions());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
