// ignore_for_file: deprecated_member_use

import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Widgets/cart_item_widget.dart';
import 'package:appshop/shared/Widgets/back_app_bar.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final CartProvider _cart = Provider.of<CartProvider>(context);
    final _items = _cart.carrinhoDeProdutos.toList();

    return Scaffold(
      appBar: BackAppBar(title: "Carrinho"),
      body: Stack(
        children: [
          _items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.remove_shopping_cart,
                        color: colorScheme.onSurface.withOpacity(0.45),
                        size: 60,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Nenhum item encontrado no carrinho.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.45),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(AppRoutes.SEARCH_PRODUCT),
                        icon: Icon(
                          Icons.storefront,
                          color: colorScheme.onPrimary,
                        ),
                        label: Text(
                          "Explorar produtos",
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _items.length + 1,
                  itemBuilder: (ctx, index) {
                    if (index == 0) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _items.length == 1
                                  ? "Revise seu pedido"
                                  : "Revise seus pedidos",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Confira os itens antes de continuar.",
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final item = _items[index - 1];

                    return CartItemWidget(item);
                  },
                ),
          if (_isLoading)
            Container(
              color: colorScheme.scrim.withOpacity(0.45),
              child: Center(
                child: CircularProgressIndicator(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _items.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Valor total",
                            style: TextStyle(
                              fontSize: 20,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              formatPrice(_cart.valorTotal),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AppRoutes.SELECIONAR_ENDERECO),
                      child: Text(
                        "COMPRAR",
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
