import 'package:flutter/cupertino.dart';
import 'package:nike/data/add_to_cart_response.dart';
import 'package:nike/data/cart_response.dart';
import 'package:nike/data/common/http_client.dart';
import 'package:nike/data/source/cart_data_source.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static ValueNotifier<int> countChangeNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);

  @override
  Future<AddToCartResponse> add(int productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) {
    throw UnimplementedError();
  }

  @override
  Future<int> count() async {
    final counts = await dataSource.count();
    countChangeNotifier.value = counts;
    return counts;
  }

  @override
  Future<void> delete(int cartItemId) => dataSource.delete(cartItemId);

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
