import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showAddToCartMessage(
      BuildContext context, String productName, VoidCallback undoAction) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text("Produto $productName adicionado ao carrinho!"),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: "DESFAZER",
          textColor: Colors.orangeAccent,
          onPressed: undoAction,
        ),
      ),
    );
  }
}
