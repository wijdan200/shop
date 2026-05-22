import 'package:equatable/equatable.dart';
import 'package:fluttershop/features/product/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final int selectedBrandIndex;

  const ProductLoaded(this.products, {this.selectedBrandIndex = 0});

  @override
  List<Object> get props => [products, selectedBrandIndex];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
