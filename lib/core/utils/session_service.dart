import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/modules/auth/providers/auth_provider.dart';
import 'package:appshop/modules/avaliacao/providers/avaliacao_provider.dart';
import 'package:appshop/modules/cart/providers/cart_provider.dart';
import 'package:appshop/modules/compras/providers/order_list_provider.dart';
import 'package:appshop/modules/endereco/providers/endereco_provider.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionService {
  Future<void> logout(BuildContext context) async {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    await context.read<AuthProvider>().deslogar();

    context.read<AvaliacaoProvider>().clear();
    context.read<CartProvider>().clear();
    context.read<OrderListProvider>().clear();
    context.read<EnderecoProvider>().clear();
    context.read<ProductProvider>().clear();

    if (!context.mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.AUTH_OR_HOME,
      (_) => false,
    );
  }
}
