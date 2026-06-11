import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/utils/show_snackbar.dart';
import 'package:appshop/modules/cart/providers/cart_provider.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductMethod {
  static Future<void> adicionarProdutoAoCarrinho({
    required BuildContext context,
    required CartProvider cart,
    required ProductModel product,
  }) async {
    ShowSnackbar.snackbarMessage(
      context: context,
      textMessage: "Produto ${product.name} adicionado ao carrinho",
      onTap: () => {
        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        Navigator.of(context).pushNamed(AppRoutes.CART),
      },
      textButton: "VISUALIZAR",
    );

    try {
      await cart.adcItemAoCarrinho(product);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbarMessage(
        context: context,
        textMessage: e.toString().replaceAll("Exception:", ""),
        onTap: () => adicionarProdutoAoCarrinho(
          context: context,
          cart: cart,
          product: product,
        ),
        textButton: "TENTE NOVAMENTE",
      );
    }
  }
}
