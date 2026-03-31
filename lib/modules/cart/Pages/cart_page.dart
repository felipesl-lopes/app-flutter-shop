import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Widgets/cart_item_widget.dart';
import 'package:appshop/modules/compras/Provider/order_list_provider.dart';
import 'package:appshop/shared/Widgets/app_drawer.dart';
import 'package:appshop/shared/Widgets/drawer_app_bar.dart';
import 'package:appshop/shared/Widgets/modal_custom.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/utils/flushbar_helper.dart';
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
    final CartProvider _cart = Provider.of<CartProvider>(context);
    final _items = _cart.items.toList();
    bool _carrinhoVazio = _items.length == 0;

    Future<void> handleBuy() async {
      setState(() => _isLoading = true);
      Navigator.of(context).pop();
      try {
        await Provider.of<OrderListProvider>(context, listen: false)
            .addOrder(_cart);
        showAppFlushbar(context,
            message: "Compra realizada com sucesso!",
            type: FlushType.success,
            position: FlushPosition.top);
      } catch (e) {
        debugPrint(e.toString());
        showAppFlushbar(context,
            message: "Erro ao finalizar compra.",
            type: FlushType.error,
            position: FlushPosition.top);
      } finally {
        setState(() => _isLoading = false);
      }
    }

    return Scaffold(
      appBar: DrawerAppBar(title: "Carrinho"),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          _carrinhoVazio
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.remove_shopping_cart,
                        color: Colors.black45,
                        size: 60,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Nenhum item encontrado no carrinho.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black45, fontSize: 16),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(AppRoutes.SEARCH_PRODUCT),
                        icon: Icon(Icons.storefront, color: Colors.white),
                        label: Text(
                          "Explorar produtos",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Card(
                      margin: EdgeInsets.all(20),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Valor total",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: 10),
                            Text(
                              formatPrice(_cart.totalAmount),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 44,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  modalCustom(
                                    context: context,
                                    onTap: handleBuy,
                                    title: "Confirmar compra?",
                                    text:
                                        "Deseja finalizar a compra dos produtos do carrinho?",
                                    icon: Icons.card_travel,
                                  );
                                },
                                child: Text(
                                  "COMPRAR",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (ctx, index) =>
                            CartItemWidget(_items[index]),
                      ),
                    ),
                  ],
                ),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
