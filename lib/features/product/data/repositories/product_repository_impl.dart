import 'package:fluttershop/features/product/data/datasources/product_remote_data_source.dart';
import 'package:fluttershop/features/product/domain/entities/product.dart';
import 'package:fluttershop/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  
  // Local storage for favorites (mimicking the original behavior in api_helper.dart)
  static final Set<int> _favoriteIds = {};

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts({int limit = 10, int skip = 0}) async {
    final products = await remoteDataSource.getProducts(limit: limit, skip: skip);
    
    // Sync with favorites
    return products.map((product) {
      if (_favoriteIds.contains(product.id)) {
        return product.copyWith(isFavorite: true);
      }
      return product;
    }).toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    final product = await remoteDataSource.getProductById(id);
    if (_favoriteIds.contains(product.id)) {
      return product.copyWith(isFavorite: true);
    }
    return product;
  }

  @override
  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
  }

  @override
  bool isFavorite(int id) => _favoriteIds.contains(id);
}
