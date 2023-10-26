import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike/data/product.dart';

final favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = 'favorites';
  final _box = Hive.box<Product>(_boxName);
  ValueListenable<Box<Product>> get listenable =>
      Hive.box<Product>(_boxName).listenable();

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());
    await Hive.openBox<Product>(_boxName);
  }

  void addFavorite(Product product) {
    _box.put(product.id, product);
  }

  void deleteFavorite(int id) {
    _box.delete(id);
  }

  List<Product> get favorites => _box.values.toList();

  bool isFavorite(int id) {
    return _box.containsKey(id);
  }
}
