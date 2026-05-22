import 'package:bloc/bloc.dart';
import 'package:fluttershop/features/product/domain/usecases/get_products_usecase.dart';
import 'package:fluttershop/features/product/domain/usecases/toggle_favorite_usecase.dart';
import 'package:fluttershop/features/product/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  ProductCubit({
    required this.getProductsUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(ProductInitial());

  Future<void> getProducts() async {
    try {
      emit(ProductLoading());
      final products = await getProductsUseCase.call();
      emit(ProductLoaded(products, selectedBrandIndex: 0));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void toggleFavorite(int productId) {
    toggleFavoriteUseCase.call(productId);
    // Refresh the list to update UI state
    getProducts(); 
  }

  void changeBrand(int index) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoaded(currentState.products, selectedBrandIndex: index));
    }
  }

  void updateProductFavoriteStatus(int productId, bool isFavorite) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final updatedProducts = currentState.products.map((p) {
        if (p.id == productId) {
          return p.copyWith(isFavorite: isFavorite);
        }
        return p;
      }).toList();
      emit(ProductLoaded(updatedProducts, selectedBrandIndex: currentState.selectedBrandIndex));
    }
  }
}
