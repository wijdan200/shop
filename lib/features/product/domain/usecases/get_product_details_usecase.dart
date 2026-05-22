import 'package:fluttershop/features/product/domain/entities/product.dart';
import 'package:fluttershop/features/product/domain/repositories/product_repository.dart';

class GetProductDetailsUseCase {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Product> call(int id) async {
    return await repository.getProductById(id);
  }
}
