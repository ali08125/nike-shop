import 'package:nike/data/product.dart';
import 'package:nike/data/source/product_data_source.dart';

import '../common/http_client.dart';


final productRepository = ProductRepository(ProductRemoteDataSource(httpClient));

abstract class IProductRepository {
  Future<List<Product>> getAll(int sort);
  Future<List<Product>> search(String searchTerm);
}

class ProductRepository implements IProductRepository {
  final IProductDataSource dataSource;

  ProductRepository(this.dataSource);
  @override
  Future<List<Product>> getAll(int sort) => dataSource.getAll(sort);

  @override
  Future<List<Product>> search(String searchTerm) =>
      dataSource.search(searchTerm);
}
