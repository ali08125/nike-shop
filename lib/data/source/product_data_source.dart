import 'package:dio/dio.dart';
import 'package:nike/data/common/http_response_validator.dart';

import '../product.dart';

abstract class IProductDataSource {
  Future<List<Product>> getAll(int sort);
  Future<List<Product>> search(String searchTerm);
}

class ProductRemoteDataSource with HttpResponseValidator implements IProductDataSource {
  final Dio httpClient;

  ProductRemoteDataSource(this.httpClient);

  @override
  Future<List<Product>> getAll(int sort) async {
    final response = await httpClient.get('product/list?sort=$sort');
    validateResponse(response);
    List<Product> products = [];
    for (var element in (response.data as List)) {
      products.add(Product.fromJson(element));
    }
    return products;
  }

  @override
  Future<List<Product>> search(String searchTerm) async{
    final response = await httpClient.get('product/list?search=$searchTerm');
    validateResponse(response);
    List<Product> products = [];
    for (var element in (response.data as List)) {
      products.add(Product.fromJson(element));
    }
    return products;
  }
}
