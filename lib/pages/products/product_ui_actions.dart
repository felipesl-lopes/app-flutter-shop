import 'package:appshop/exceptions/exception.dart';
import 'package:appshop/models/auth/auth.dart';
import 'package:appshop/models/product.dart';
import 'package:flutter/material.dart';

class ProductUiActions {
  /**
   * Função que favorita/desfavorita o produto.
   */
  static Future<void> toggleFavoriteProduct(
    BuildContext context,
    Product product,
    Auth auth,
  ) async {
    final msg = ScaffoldMessenger.of(context);

    try {
      await product.toggleFavorite(
        auth.token ?? "",
        auth.userId ?? "",
        auth.email ?? "",
      );
    } on ExceptionMsg catch (error) {
      msg.showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }
}
