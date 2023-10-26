import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/home/bloc/home_bloc.dart';
import 'package:nike/ui/productList/product_list.dart';
import 'package:nike/ui/widgets/product_sort.dart';

import '../../data/repo/banner_repository.dart';
import '../../data/repo/product_repository.dart';
import '../widgets/banner_slider.dart';
import '../widgets/error_screen.dart';
import '../widgets/horizontal_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final homeBloc = HomeBloc(bannerRepository, productRepository);
        homeBloc.add(HomeStarted());
        cartRepository.count();
        return homeBloc;
      },
      child: SafeArea(
        child: Scaffold(body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                physics: defaultScroll,
                itemCount: 5,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Container(
                        alignment: Alignment.center,
                        height: 52,
                        child: Image.asset(
                          'assets/img/nike_logo.png',
                          height: 28,
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    case 2:
                      return BannerSlider(
                        banners: state.banners,
                      );
                    case 3:
                      return HorizontalProductList(
                        state: state.latestProducts,
                        title: 'جدیدترین ها',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>  ProductListScreen(
                              sort: ProductSort.latest,
                            ),
                          ));
                        },
                      );
                    case 4:
                      return HorizontalProductList(
                        state: state.popularProducts,
                        title: 'محبوب ترین ها',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>  ProductListScreen(
                              sort: ProductSort.popular,
                            ),
                          ));
                        },
                      );
                    default:
                      return Container(
                        color: Colors.red,
                      );
                  }
                },
              );
            } else if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is HomeError) {
              return ErrorScreen(
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                },
                exception: AppExceptions(),
              );
            } else {
              return const Text('state not found!!');
            }
          },
        )),
      ),
    );
  }
}
