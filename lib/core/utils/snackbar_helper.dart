import 'package:appshop/core/constants/app_routes.dart';
import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showAddToCartMessage(
      BuildContext context, String productName) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text("Produto $productName adicionado ao carrinho!"),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: "VISUALIZAR",
          textColor: Colors.orangeAccent,
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.CART),
        ),
      ),
    );
  }
}
