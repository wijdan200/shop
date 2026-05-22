import 'package:fluttershop/features/product/domain/entities/product.dart';

abstract class ProductdetailsState {}

class ProductdetailsInitial extends ProductdetailsState {
  final int quantity;
  final int selectedSize;
  final bool isFavorite;
  ProductdetailsInitial({
    this.quantity = 1,
    this.selectedSize = 38,
    this.isFavorite = false,
  });
}

class ProductLoading extends ProductdetailsState {}

class ProductLoaded extends ProductdetailsState {
  final Product product;
  final int quantity;
  final int selectedSize;
  final bool isFavorite;

  ProductLoaded({
    required this.product,
    this.quantity = 1,
    this.selectedSize = 38,
    this.isFavorite = false,
  });
}

class ProductError extends ProductdetailsState {
  final String message;
  ProductError(this.message);
}
