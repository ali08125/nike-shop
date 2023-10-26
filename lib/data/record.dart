import 'package:nike/data/product.dart';

class Record {
  final int id;
  final int price;
  final List<Product> products;

  Record(this.id, this.price, this.products);

  Record.fromJson(dynamic json)
      : id = json['id'],
        price = json['payable'],
        products = (json['order_items'] as List).map((element) {
          return Product.fromJson(element['product']);
        }).toList();
}
