import 'package:dio/dio.dart';
import 'package:nike/data/cart_response.dart';
import 'package:nike/data/common/http_response_validator.dart';

import '../add_to_cart_response.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRemoteDataSource
    with HttpResponseValidator
    implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource(this.httpClient);
  @override
  Future<AddToCartResponse> add(int productId) async {
    final response =
        await httpClient.post('cart/add', data: {'product_id': productId});
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  //Future<Cart> changeCount(int cartItemId, int count) async {}

  @override
  Future<int> count() async {
    final response = await httpClient.get('cart/count');
    return response.data['count'];
  }

  @override
  Future<void> delete(int cartItemId) async {
    await httpClient.post('cart/remove', data: {
      'cart_item_id': cartItemId,
    });
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) {
    throw UnimplementedError();
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get('cart/list');

    return CartResponse.fromJson(response.data);
  }
}
