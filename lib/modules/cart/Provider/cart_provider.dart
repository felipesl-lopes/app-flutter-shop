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

  CartProvider(
    this.auth,
    this._cartRepository,
    this._productProvider,
  );

  Timer? _debounce;
  String get _userId => auth.userId ?? '';

  List<CartItemModel> _carrinhoDeProdutos = [];
  List<CartItemModel> get carrinhoDeProdutos => [..._carrinhoDeProdutos];

  void setCarrinhoDeProdutos(List<CartItemModel> value) {
    _carrinhoDeProdutos = value;
    notifyListeners();
  }

  int get totalDeItens {
    return _carrinhoDeProdutos.length;
  }

  double get valorTotal {
    return _carrinhoDeProdutos.fold(
      0.0,
      (total, item) {
        final preco = item.product.valorFinalDoProduto();
        return total + (preco * item.quantity);
      },
    );
  }

  Future<void> carregarCarrinho() async {
    try {
      if (_productProvider.produtos.isEmpty) {
        await _productProvider.carregarProdutos();
      }

      final productsMap = {for (var p in _productProvider.produtos) p.id: p};

      final data = await _cartRepository.carregarCarrinho(
        userId: _userId,
        productsMap: productsMap,
      );

      setCarrinhoDeProdutos(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> adcItemAoCarrinho(dynamic product) async {
    final index =
        _carrinhoDeProdutos.indexWhere((e) => e.product.id == product.id);

    late CartItemModel updatedItem;

    if (index >= 0) {
      final existing = _carrinhoDeProdutos[index];

      if (existing.quantity == product.quantity) {
        throw Exception("Quantidade máxima atingida.");
      }

      updatedItem = CartItemModel(
        product: existing.product,
        quantity: existing.quantity + 1,
      );

      _carrinhoDeProdutos[index] = updatedItem;
    } else {
      updatedItem = CartItemModel(
        product: product,
        quantity: 1,
      );

      _carrinhoDeProdutos.add(updatedItem);
    }

    notifyListeners();
    _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: 400), () async {
      try {
        final item = _carrinhoDeProdutos
            .firstWhere((e) => e.product.id == updatedItem.product.id);

        await _cartRepository.atualizarQuantidadeDeItens(
          productId: item.product.id,
          quantity: item.quantity,
          userId: _userId,
        );
      } catch (e) {
        debugPrint('Erro ao adicionar produto: $e');

        final index = _carrinhoDeProdutos
            .indexWhere((e) => e.product.id == updatedItem.product.id);

        if (index >= 0) {
          if (_carrinhoDeProdutos[index].quantity > 1) {
            _carrinhoDeProdutos[index] = CartItemModel(
              product: updatedItem.product,
              quantity: _carrinhoDeProdutos[index].quantity - 1,
            );
          } else {
            _carrinhoDeProdutos.removeAt(index);
          }
        }

        notifyListeners();
      }
    });
  }

  Future<void> removeSingleItem(String productId) async {
    final index =
        _carrinhoDeProdutos.indexWhere((e) => e.product.id == productId);

    if (index < 0) return;

    final existing = _carrinhoDeProdutos[index];

    if (existing.quantity == 1) {
      _carrinhoDeProdutos.removeAt(index);
    } else {
      _carrinhoDeProdutos[index] = CartItemModel(
        product: existing.product,
        quantity: existing.quantity - 1,
      );
    }

    notifyListeners();

    _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: 400), () async {
      try {
        final itemIndex = _carrinhoDeProdutos.indexWhere(
          (e) => e.product.id == productId,
        );

        final quantity =
            itemIndex >= 0 ? _carrinhoDeProdutos[itemIndex].quantity : 0;

        await _cartRepository.atualizarQuantidadeDeItens(
          productId: productId,
          quantity: quantity,
          userId: _userId,
        );
      } catch (e) {
        debugPrint('Erro ao atualizar produto: $e');
      }
    });
  }

  void limparCarrinho() {
    _carrinhoDeProdutos = [];
    notifyListeners();
  }
}
