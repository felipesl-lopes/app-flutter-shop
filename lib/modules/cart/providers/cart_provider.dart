import 'dart:async';

import 'package:appshop/modules/cart/models/cart_product_model.dart';
import 'package:appshop/modules/cart/repositories/cart_repository.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CartProvider with ChangeNotifier {
  final CartRepository _cartRepository;
  final ProductProvider _productProvider;

  late final Command0<List<CartProductModel>> loadCartCommand;

  CartProvider(
    this._cartRepository,
    this._productProvider,
  ) {
    loadCartCommand = Command0(_loadCart);
  }

  Timer? _debounce;

  List<CartProductModel> _carrinhoDeProdutos = [];
  List<CartProductModel> get carrinhoDeProdutos => [..._carrinhoDeProdutos];

  void setCarrinhoDeProdutos(List<CartProductModel> value) {
    _carrinhoDeProdutos = value;
    notifyListeners();
  }

  void clear() {
    _carrinhoDeProdutos.clear();
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

  Future<Result<List<CartProductModel>>> _loadCart() async {
    try {
      if (_productProvider.produtos.isEmpty) {
        await _productProvider.loadProductsCommand.execute();
      }

      final productsMap = {for (var p in _productProvider.produtos) p.id: p};

      final data = await _cartRepository.carregarCarrinho(
        productsMap: productsMap,
      );

      setCarrinhoDeProdutos(data);

      return Success(data);
    } catch (e) {
      return Failure(
        Exception(e.toString()),
      );
    }
  }

  Future<void> adcItemAoCarrinho(ProductModel product) async {
    final index =
        _carrinhoDeProdutos.indexWhere((e) => e.product.id == product.id);

    late CartProductModel updatedItem;

    if (index >= 0) {
      final existing = _carrinhoDeProdutos[index];

      if (existing.quantity == product.quantity) {
        throw Exception("Quantidade máxima atingida.");
      }

      updatedItem = CartProductModel(
        product: existing.product,
        quantity: existing.quantity + 1,
      );

      _carrinhoDeProdutos[index] = updatedItem;
    } else {
      updatedItem = CartProductModel(
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
        );
      } catch (e) {
        debugPrint('Erro ao adicionar produto: $e');

        final index = _carrinhoDeProdutos
            .indexWhere((e) => e.product.id == updatedItem.product.id);

        if (index >= 0) {
          if (_carrinhoDeProdutos[index].quantity > 1) {
            _carrinhoDeProdutos[index] = CartProductModel(
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
      _carrinhoDeProdutos[index] = CartProductModel(
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
