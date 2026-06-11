import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/cart/models/cart_product_model.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:flutter/material.dart';

class CartRepository {
  final IHttpClient client;

  CartRepository(this.client);

  Future<List<CartProductModel>> carregarCarrinho({
    required String userId,
    required Map<String, ProductModel> productsMap,
  }) async {
    debugPrint('[CartRepository]: getCart');
    try {
      final response = await client.get('cartProducts/$userId');
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
    required String userId,
  }) async {
    debugPrint('[CartRepository]: updateItemQuantity');

    try {
      final response = await client.get('cartProducts/$userId/$productId');

      if (response.data == null) {
        await client.put('cartProducts/$userId/$productId',
            body: {'productId': productId, 'quantity': quantity});
        return;
      }

      if (quantity <= 0) {
        await client.delete('cartProducts/$userId/$productId');
      } else {
        await client.patch(
          'cartProducts/$userId/$productId',
          body: {'quantity': quantity},
        );
      }
    } catch (_) {
      throw Exception('Erro ao adicionar/remover quantidade.');
    }
  }

  Future<void> limparCarrinho({required String userId}) async {
    debugPrint('[CartRepository]: limparCarrinho');

    try {
      await client.delete('cartProducts/$userId');
    } catch (_) {
      throw Exception('Erro ao limpar carrinho.');
    }
  }
}
