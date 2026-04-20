import 'dart:async';

import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/cart/Repository/cart_repository.dart';
import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/shared/Models/cart_item_model.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final AuthProvider auth;
  final CartRepository _cartRepository;
  final ProductProvider _productProvider;

  CartProvider(this.auth, this._cartRepository, this._productProvider);

  Timer? _debounce;
  String get _userId => auth.userId ?? '';

  List<CartItemModel> _items = [];
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
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  Future<void> loadCart() async {
    try {
      if (_productProvider.produtos.isEmpty) {
        await _productProvider.carregarProdutos();
      }

      final productsMap = {for (var p in _productProvider.produtos) p.id: p};

      final data = await _cartRepository.getCart(
        userId: _userId,
        productsMap: productsMap,
      );

      setItems(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addItem(dynamic product) async {
    final index = _items.indexWhere((e) => e.product.id == product.id);

    late CartItemModel updatedItem;

    if (index >= 0) {
      final existing = _items[index];

      updatedItem = CartItemModel(
        product: existing.product,
        quantity: existing.quantity + 1,
      );

      _items[index] = updatedItem;
    } else {
      updatedItem = CartItemModel(
        product: product,
        quantity: 1,
      );

      _items.add(updatedItem);
    }

    notifyListeners();
    _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: 400), () async {
      try {
        final item =
            _items.firstWhere((e) => e.product.id == updatedItem.product.id);

        await _cartRepository.updateItemQuantity(
          productId: item.product.id,
          quantity: item.quantity,
          userId: _userId,
        );
      } catch (e) {
        debugPrint('Erro ao adicionar produto: $e');

        final index =
            _items.indexWhere((e) => e.product.id == updatedItem.product.id);

        if (index >= 0) {
          if (_items[index].quantity > 1) {
            _items[index] = CartItemModel(
              product: updatedItem.product,
              quantity: _items[index].quantity - 1,
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
    final index = _items.indexWhere((e) => e.product.id == productId);

    if (index < 0) return;

    final existing = _items[index];

    if (existing.quantity == 1) {
      _items.removeAt(index);
    } else {
      _items[index] = CartItemModel(
        product: existing.product,
        quantity: existing.quantity - 1,
      );
    }

    notifyListeners();

    _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: 400), () async {
      try {
        final itemIndex = _items.indexWhere(
          (e) => e.product.id == productId,
        );

        final quantity = itemIndex >= 0 ? _items[itemIndex].quantity : 0;

        await _cartRepository.updateItemQuantity(
          productId: productId,
          quantity: quantity,
          userId: _userId,
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
