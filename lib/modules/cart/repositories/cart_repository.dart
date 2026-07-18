import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/cart/models/cart_product_model.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:flutter/material.dart';

class CartRepository {
  final IHttpClient _client;

  CartRepository(this._client);

  Future<List<CartProductModel>> carregarCarrinho({
    required Map<String, ProductModel> productsMap,
  }) async {
    debugPrint('[CartRepository]: getCart');
    try {
      final response = await _client.get('cartProducts');

      final data = response.data;

      if (data == null) return [];

      final List<CartProductModel> items = [];

      data.forEach((key, value) {
        final item = Map<String, dynamic>.from(value);

        final productId = key;
        final product = productsMap[productId];

        if (product != null) {
          items.add(
            CartProductModel.fromMap(item, product),
          );
        }
      });
      return items;
    } catch (_) {
      throw Exception('Erro ao carregar carrinho.');
    }
  }

  Future<void> atualizarQuantidadeDeItens({
    required String productId,
    required int quantity,
  }) async {
    debugPrint('[CartRepository]: updateItemQuantity');

    try {
      await _client.patch('cartProducts/$productId', body: {
        'quantity': quantity,
      });
    } catch (_) {
      throw Exception('Erro ao adicionar/remover quantidade.');
    }
  }

  Future<void> limparCarrinho({required String userId}) async {
    debugPrint('[CartRepository]: limparCarrinho');

    try {
      await _client.delete('cartProducts/$userId');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao limpar carrinho.');
    }
  }
}
