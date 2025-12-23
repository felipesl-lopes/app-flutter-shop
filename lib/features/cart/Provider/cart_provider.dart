import 'package:appshop/features/cart/Models/cart_item_model.dart';
import 'package:appshop/features/product/Provider/product.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItemModel(
            id: existingItem.id,
            name: existingItem.name,
            quantity: existingItem.quantity + 1,
            price: existingItem.price,
            imageUrl: product.imageUrl),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItemModel(
          id: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
          imageUrl: product.imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItemModel(
          id: existingItem.id,
          name: existingItem.name,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
