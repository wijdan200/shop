import 'package:fluttershop/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int limit = 10, int skip = 0});
  Future<Product> getProductById(int id);
  void toggleFavorite(int id);
  bool isFavorite(int id);
}
