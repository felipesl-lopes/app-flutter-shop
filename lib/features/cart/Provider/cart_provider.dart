import 'package:appshop/core/models/cart_item_model.dart';
import 'package:appshop/core/models/product_model.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  String _extractImageUrl(dynamic product) {
    if (product is ProductModel) {
      return product.imageUrls.isNotEmpty ? product.imageUrls.first.value : '';
    }

    if (product is CartItemModel) {
      return product.imageUrl;
    }

    return '';
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(dynamic product) {
    final imageUrl = _extractImageUrl(product);

    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItemModel(
          id: existingItem.id,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
          imageUrl: imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItemModel(
          id: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removerItem(dynamic product) {
    if (!_items.containsKey(product.id)) return;

    final existingItem = _items[product.id]!;

    _items.update(
      product.id,
      (_) => CartItemModel(
        id: existingItem.id,
        name: existingItem.name,
        quantity: existingItem.quantity - 1,
        price: existingItem.price,
        imageUrl: existingItem.imageUrl,
      ),
    );

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
