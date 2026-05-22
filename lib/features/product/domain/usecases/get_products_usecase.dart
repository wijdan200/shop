import 'package:fluttershop/features/product/domain/entities/product.dart';
import 'package:fluttershop/features/product/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call({int limit = 10, int skip = 0}) async {
    return await repository.getProducts(limit: limit, skip: skip);
  }
}
