import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:nike/ui/cart/bloc/cart_bloc.dart';
import 'package:nike/ui/widgets/price_info.dart';
import 'package:nike/ui/shipping/shipping.dart';
import 'package:nike/ui/widgets/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StreamSubscription? _streamSubscription;
  final RefreshController _refreshController = RefreshController();
  CartBloc? cartBloc;
  bool stateIsSuccess = false;

  @override
  void initState() {
    AuthRepository.authChangeNotifir.addListener(authInfoChanged);
    super.initState();
  }

  void authInfoChanged() {
    cartBloc?.add(CartAuthChanged(AuthRepository.authChangeNotifir.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifir.removeListener(authInfoChanged);
    cartBloc?.close();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CartBloc(cartRepository);
        cartBloc = bloc;
        _streamSubscription = bloc.stream.listen((state) {
          setState(() {
            stateIsSuccess = state is CartSuccess;
          });
          if (_refreshController.isRefresh) {
            if (state is CartSuccess) {
              _refreshController.refreshCompleted();
            } else if (state is CartError) {
              _refreshController.refreshFailed();
            }
          }
        });
        bloc.add(CartStarted(AuthRepository.authChangeNotifir.value));
        return bloc;
      },
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: stateIsSuccess,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 48),
            child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      final state = cartBloc?.state;
                      if (state is CartSuccess) {
                        return ShippingScreen(
                            totalPrice: state.response.totalPrice,
                            payablePrice: state.response.payablePrice,
                            shippingCost: state.response.shippingCost);
                      } else {
                        return Container();
                      }
                    },
                  ));
                },
                label: const Text('پرداخت')),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('سبد خرید'),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is CartSuccess) {
              return SmartRefresher(
                controller: _refreshController,
                header: const ClassicHeader(
                  completeText: 'با موفقیت انجام شد',
                  refreshingText: 'درحال به روزرسانی',
                  idleText: 'برای به روزرسانی پایین بکشید',
                  releaseText: 'رها کنید',
                  failedText: 'خطای نامشخص',
                  spacing: 2.2,
                  refreshingIcon: CupertinoActivityIndicator(),
                ),
                onRefresh: () {
                  cartBloc?.add(CartStarted(
                      AuthRepository.authChangeNotifir.value,
                      isRefreshing: true));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 72),
                  physics: defaultScroll,
                  itemCount: state.response.cartItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.response.cartItems.length) {
                      final data = state.response.cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CartItem(
                          onDeleteButtonClicked: () {
                            cartBloc?.add(CartDeleteButtonClicked(data.id));
                          },
                          item: data,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PriceInfo(
                          totalPrice: state.response.totalPrice,
                          payablePrice: state.response.payablePrice,
                          shippingCost: state.response.shippingCost,
                        ),
                      );
                    }
                  },
                ),
              );
            } else if (state is CartAuthRequired) {
              return EmptyView(
                  message:
                      'برای مشاهده سبد خرید ابتدا وارد حساب کاربری خود شوید',
                  image: SvgPicture.asset(
                    'assets/img/auth_required.svg',
                    width: 140,
                  ),
                  callToAction: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ));
                      },
                      child: const Text('ورود به حساب کاربری')));
            } else if (state is CartEmpty) {
              return Center(
                child: EmptyView(
                    message: 'محصولی به سبد خرید خود اضافه نکرده اید',
                    image: SvgPicture.asset(
                      'assets/img/empty_cart.svg',
                      width: 200,
                    )),
              );
            } else {
              return const Text('state is not valid!!!');
            }
          },
        ),
      ),
    );
  }
}
