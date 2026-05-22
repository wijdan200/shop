import 'package:bloc/bloc.dart';
import 'package:fluttershop/features/product/domain/usecases/get_product_details_usecase.dart';
import 'package:fluttershop/features/product/domain/usecases/toggle_favorite_usecase.dart';
import 'package:fluttershop/features/product/presentation/cubit/details_state.dart';
import 'package:fluttershop/features/product/domain/entities/product.dart';

class ProductDetailsCubit extends Cubit<ProductdetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  ProductDetailsCubit({
    required this.getProductDetailsUseCase,
    required this.toggleFavoriteUseCase,
    required bool? initialFavorite,
  }) : super(ProductdetailsInitial(isFavorite: initialFavorite ?? false));

  Future<void> getProductDetails(int id) async {
    emit(ProductLoading());
    try {
      final product = await getProductDetailsUseCase.call(id);
      emit(ProductLoaded(product: product));
    } catch (e) {
      emit(ProductError("Failed to load product"));
    }
  }

  void selectSize(int size) {
    if (state is ProductdetailsInitial) {
      final currentState = state as ProductdetailsInitial;
      emit(ProductdetailsInitial(
        selectedSize: size,
        isFavorite: currentState.isFavorite,
      ));
    } else if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoaded(
        product: currentState.product,
        selectedSize: size,
        isFavorite: currentState.isFavorite,
      ));
    }
  }

  void toggleFavorite(Product? product) {
    if (product != null) {
      toggleFavoriteUseCase.call(product.id);
    }

    if (state is ProductdetailsInitial) {
      final currentState = state as ProductdetailsInitial;
      emit(ProductdetailsInitial(
        selectedSize: currentState.selectedSize,
        isFavorite: !currentState.isFavorite,
      ));
    } else if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoaded(
        product: currentState.product,
        selectedSize: currentState.selectedSize,
        isFavorite: !currentState.isFavorite,
      ));
    }
  }
}
