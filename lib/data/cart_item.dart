import 'package:nike/data/product.dart';

class CartItemEntity {
  final Product product;
  final int id;
  final int count;
  bool deleteButtonLoading = false;
  bool changeCountLoading = false;

  CartItemEntity(this.product, this.id, this.count);
  CartItemEntity.fromJson(dynamic json)
      : product = Product.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArray) {
    List<CartItemEntity> items = [];

    for (var element in jsonArray) {
      items.add(CartItemEntity.fromJson(element));
    }

    return items;
  }
}
