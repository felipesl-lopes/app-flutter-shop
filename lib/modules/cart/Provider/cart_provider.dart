import 'dart:async';

import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/cart/Repository/cart_repository.dart';
import 'package:appshop/shared/Models/cart_item_model.dart';
import 'package:appshop/shared/Models/product_model.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final AuthProvider auth;
  final CartRepository _cartRepository;
  List<CartItemModel> _items = [];

  CartProvider(this.auth, this._cartRepository);

  Timer? _debounce;

  String get _userId => auth.userId ?? '';

  List<CartItemModel> get items => [..._items];

  void setItems(List<CartItemModel> value) {
    _items = value;
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    return _items.fold(
      0.0,
      (total, item) => total + (item.price * item.quantity),
    );
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

  Future<void> loadCart() async {
    try {
      final data = await _cartRepository.getCart(userId: _userId);
      setItems(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addItem(dynamic product) async {
    final imageUrl = _extractImageUrl(product);

    final index = _items.indexWhere((e) => e.id == product.id);

    late CartItemModel updatedItem;

    if (index >= 0) {
      final existing = _items[index];

      updatedItem = CartItemModel(
        id: existing.id,
        name: existing.name,
        quantity: existing.quantity + 1,
        price: existing.price,
        imageUrl: existing.imageUrl,
      );

      _items[index] = updatedItem;
    } else {
      updatedItem = CartItemModel(
        id: product.id,
        name: product.name,
        quantity: 1,
        price: product.price,
        imageUrl: imageUrl,
      );

      _items.add(updatedItem);
    }

    notifyListeners();
    _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: 400), () async {
      try {
        final item = _items.firstWhere((e) => e.id == updatedItem.id);

        await _cartRepository.updateItemQuantity(
          productId: item.id,
          quantity: item.quantity,
          userId: _userId,
          item: item,
        );
      } catch (e) {
        debugPrint('Erro ao adicionar produto: $e');

        final index = _items.indexWhere((e) => e.id == updatedItem.id);

        if (index >= 0) {
          if (_items[index].quantity > 1) {
            _items[index] = CartItemModel(
              id: updatedItem.id,
              name: updatedItem.name,
              quantity: _items[index].quantity - 1,
              price: updatedItem.price,
              imageUrl: updatedItem.imageUrl,
            );
          } else {
            _items.removeAt(index);
          }
        }

        notifyListeners();
      }
    });
  }

  Future<void> removeSingleItem(String productId) async {
    final index = _items.indexWhere((e) => e.id == productId);

    if (index < 0) return;

    final existing = _items[index];

    if (existing.quantity == 1) {
      _items.removeAt(index);
    } else {
      _items[index] = CartItemModel(
        id: existing.id,
        name: existing.name,
        quantity: existing.quantity - 1,
        price: existing.price,
        imageUrl: existing.imageUrl,
      );
    }

    notifyListeners();

    _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: 400), () async {
      try {
        final item = _items.firstWhere(
          (e) => e.id == productId,
          orElse: () => CartItemModel(
            id: productId,
            name: '',
            quantity: 0,
            price: 0,
            imageUrl: '',
          ),
        );

        await _cartRepository.updateItemQuantity(
          productId: item.id,
          quantity: item.quantity,
          userId: _userId,
          item: item,
        );
      } catch (e) {
        debugPrint('Erro ao atualizar produto: $e');
      }
    });
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
