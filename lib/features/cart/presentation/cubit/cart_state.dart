import 'package:equatable/equatable.dart';
import 'package:fluttershop/features/product/domain/entities/product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final int size;

  const CartItem({
    required this.product,
    this.quantity = 1,
    required this.size,
  });

  CartItem copyWith({Product? product, int? quantity, int? size}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }

  double get totalPrice => product.price * quantity.toDouble();

  @override
  List<Object?> get props => [product, quantity, size];
}

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({this.items = const []});

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  List<Object> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
