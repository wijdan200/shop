import 'package:bloc/bloc.dart';
import 'package:fluttershop/features/product/domain/entities/product.dart';
import 'package:fluttershop/features/cart/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<CartItem> _items = [];

  void addToCart(Product product, int size) {
    if (state is CartInitial) {
      emit(CartLoaded(items: []));
    }

    // Check if item already exists with same product ID and size
    final index = _items.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );

    if (index >= 0) {
      // Update quantity
      final existingItem = _items[index];
      _items[index] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
     
      _items.add(CartItem(product: product, size: size));
    }

    emit(CartLoaded(items: List.from(_items)));
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    emit(CartLoaded(items: List.from(_items)));
  }

  void incrementQuantity(CartItem item) {
    final index = _items.indexOf(item);
    if (index >= 0) {
      _items[index] = item.copyWith(quantity: item.quantity + 1);
      emit(CartLoaded(items: List.from(_items)));
    }
  }

  void decrementQuantity(CartItem item) {
    final index = _items.indexOf(item);
    if (index >= 0) {
      if (item.quantity > 1) {
        _items[index] = item.copyWith(quantity: item.quantity - 1);
      } else {
        _items.removeAt(index);
      }
      emit(CartLoaded(items: List.from(_items)));
    }
  }

void clearCart(){
  _items.clear();
  emit(CartLoaded(items: []));
}

 
}
