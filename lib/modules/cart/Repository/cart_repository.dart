import 'dart:convert';

import 'package:appshop/shared/Models/cart_item_model.dart';
import 'package:appshop/shared/utils/constants.dart';
import 'package:http/http.dart' as http;

class CartRepository {
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

  Future<void> updateItemQuantity({
    required String productId,
    required int quantity,
    required String userId,
    required String token,
    required CartItemModel item,
  }) async {
    final url =
        "${Constants.CART_PRODUCTS_URL}/$userId/$productId.json?auth=$token";

    final response = await http.get(Uri.parse(url));

    if (response.body == 'null') {
      await http.put(
        Uri.parse(url),
        body: jsonEncode(item.toJson()),
      );
      return;
    }

    if (quantity <= 0) {
      await http.delete(Uri.parse(url));
    } else {
      await http.patch(
        Uri.parse(url),
        body: jsonEncode({'quantity': quantity}),
      );
    }
  }
}
