import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/repo/order_repository.dart';
import 'package:nike/ui/receipt/payment_receipt.dart';
import 'package:nike/ui/shipping/bloc/shipping_bloc.dart';
import 'package:nike/ui/widgets/payment_webview.dart';
import 'package:nike/ui/widgets/price_info.dart';

class ShippingScreen extends StatefulWidget {
  final int totalPrice;
  final int payablePrice;
  final int shippingCost;
  const ShippingScreen(
      {super.key,
      required this.totalPrice,
      required this.payablePrice,
      required this.shippingCost});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  StreamSubscription? subscription;
  final TextEditingController _nameController =
      TextEditingController(text: 'ali');

  final TextEditingController _lastNameController =
      TextEditingController(text: 'asfas');

  final TextEditingController _phoneController =
      TextEditingController(text: '09155659755');

  final TextEditingController _postalCodeController =
      TextEditingController(text: '1111111111');

  final TextEditingController _adressController =
      TextEditingController(text: 'adpsofcadonvadonvolanlov');

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
        centerTitle: false,
      ),
      body: BlocProvider(
          create: (context) {
            final bloc = ShippingBloc(orderRepository);
            subscription = bloc.stream.listen((state) {
              if (state is ShippingSuccess) {
                if (state.result.bankGatewayUrl.isNotEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentGatewayScreen(
                            bankGatewayUrl: state.result.bankGatewayUrl),
                      ));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentReceiptScreen(
                      orderId: state.result.orderId,
                    ),
                  ));
                }
              } else if (state is ShippingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.exceptions.message)));
              }
            });
            return bloc;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(label: Text('نام')),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _lastNameController,
                  decoration:
                      const InputDecoration(label: Text('نام خانوادگی')),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(label: Text('شماره تماس')),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _postalCodeController,
                  decoration: const InputDecoration(label: Text('کد پستی')),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _adressController,
                  decoration: const InputDecoration(label: Text('آدرس')),
                ),
                const SizedBox(
                  height: 24,
                ),
                PriceInfo(
                    totalPrice: widget.totalPrice,
                    payablePrice: widget.payablePrice,
                    shippingCost: widget.shippingCost),
                const SizedBox(
                  height: 24,
                ),
                BlocBuilder<ShippingBloc, ShippingState>(
                  builder: (context, state) {
                    return state is ShippingLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                  onPressed: () {
                                    BlocProvider.of<ShippingBloc>(context).add(
                                        ShippingSubmit(CreateOrderParams(
                                            _nameController.text,
                                            _lastNameController.text,
                                            _postalCodeController.text,
                                            _phoneController.text,
                                            _adressController.text,
                                            PaymentMethod.cashOnDelivery)));
                                  },
                                  child: const Text('پرداخت در محل')),
                              const SizedBox(
                                width: 16,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<ShippingBloc>(context).add(
                                        ShippingSubmit(CreateOrderParams(
                                            _nameController.text,
                                            _lastNameController.text,
                                            _postalCodeController.text,
                                            _phoneController.text,
                                            _adressController.text,
                                            PaymentMethod.directCash)));
                                  },
                                  child: const Text('پرداخت اینترنتی')),
                            ],
                          );
                  },
                )
              ]),
            ),
          )),
    );
  }
}
