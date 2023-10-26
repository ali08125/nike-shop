import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final int discount;
  @HiveField(5)
  final int previousPrice;

  Product(this.id, this.title, this.imageUrl, this.price, this.discount,
      this.previousPrice);

  Product.fromJson(dynamic json)
      : id = json['id'],
        title = json['title'],
        price = json['price'],
        discount = json['discount'],
        imageUrl = json['image'],
        previousPrice =
            json['previous_price'] ?? json['price'] + json['discount'];
}
