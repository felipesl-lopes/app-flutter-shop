import 'dart:convert';

import 'package:appshop/shared/Models/cart_item_model.dart';
import 'package:appshop/shared/utils/constants.dart';
import 'package:http/http.dart' as http;

class CartRepository {
  Future<Map<String, dynamic>> _getCart(
    String userId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse("${Constants.CART_PRODUCTS_URL}/$userId.json?auth=$token"),
    );

    if (response.body == 'null') return {};

    return jsonDecode(response.body);
  }

  Future<List<CartItemModel>> getCart({
    required String userId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse("${Constants.CART_PRODUCTS_URL}/$userId.json?auth=$token"),
    );

    final decoded = jsonDecode(response.body);

    if (decoded == null) return [];

    if (decoded is! Map<String, dynamic>) return [];

    final List<CartItemModel> items = [];

    decoded.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        items.add(CartItemModel.fromJson(value));
      }
    });

    return items;
  }

  Future<void> adicionarProdutoAoCarrinho({
    required String userId,
    required String token,
    required CartItemModel itemCart,
  }) async {
    final url =
        "${Constants.CART_PRODUCTS_URL}/$userId/${itemCart.id}.json?auth=$token";

    final response = await http.get(Uri.parse(url));

    if (response.body != 'null') {
      final data = jsonDecode(response.body);

      final updateQuantity = data['quantity'] + 1;

      await http.patch(
        Uri.parse(url),
        body: jsonEncode({'quantity': updateQuantity}),
      );
    } else {
      await http.put(Uri.parse(url), body: jsonEncode(itemCart.toJson()));
    }
  }

  Future<void> removerItem({
    required String productId,
    required String userId,
    required String token,
  }) async {
    final url =
        "${Constants.CART_PRODUCTS_URL}/$userId/$productId.json?auth=$token";

    final response = await http.get(Uri.parse(url));

    if (response.body == 'null') return;

    final data = jsonDecode(response.body);

    final quantity = data['quantity'];

    if (quantity > 1) {
      await http.patch(
        Uri.parse(url),
        body: jsonEncode({
          'quantity': quantity - 1,
        }),
      );
    } else {
      await http.delete(Uri.parse(url));
    }
  }

  Future<void> removerItemCompleto({
    required String productId,
    required String userId,
    required String token,
  }) async {
    await http.delete(
      Uri.parse(
          "${Constants.CART_PRODUCTS_URL}/$userId/$productId.json?auth=$token"),
    );
  }
}
