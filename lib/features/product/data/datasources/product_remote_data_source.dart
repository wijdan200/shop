import 'package:dio/dio.dart';
import 'package:fluttershop/features/product/domain/entities/product.dart';
import 'package:fluttershop/core/config/app_config.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts({int limit = 10, int skip = 0});
  Future<Product> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Product>> getProducts({int limit = 10, int skip = 0}) async {
    try {
      final response = await dio.get(
        '${AppConfig.baseUrl}/products',
        queryParameters: {'limit': limit, 'skip': skip},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final response = await dio.get('${AppConfig.baseUrl}/products/$id');

      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
}
