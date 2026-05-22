import 'package:fluttershop/features/product/domain/repositories/product_repository.dart';
import 'package:fluttershop/helper/app_logg.dart';

class ToggleFavoriteUseCase {
  final ProductRepository repository;

  ToggleFavoriteUseCase(this.repository,){
AppLogger.debug('Wijdan ToggleFavoriteUseCase');
  }

  void call(int id) {
    repository.toggleFavorite(id);
  }
}
