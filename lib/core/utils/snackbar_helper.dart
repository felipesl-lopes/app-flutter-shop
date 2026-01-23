import 'package:appshop/core/constants/app_routes.dart';
import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showAddToCartMessage(BuildContext context, String productName) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 4),
        dismissDirection: DismissDirection.down,
        content: Row(
          children: [
            Expanded(
                child: Text("Produto $productName adicionado ao carrinho!")),
            TextButton(
                onPressed: () => {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                      Navigator.of(context).pushNamed(AppRoutes.CART),
                    },
                child: Text(
                  "VISUALIZAR",
                  style: TextStyle(color: Colors.orangeAccent),
                )),
          ],
        ),
      ),
    );
  }
}
