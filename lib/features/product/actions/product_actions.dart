import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/features/auth/Provider/auth.dart';
import 'package:appshop/features/product/Provider/product.dart';
import 'package:flutter/material.dart';

class ProductActions {
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
    } on GenericExeption catch (error) {
      msg.showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }
}
