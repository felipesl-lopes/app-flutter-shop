import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/cart/Widgets/cart_item_widget.dart';
import 'package:appshop/features/compras/Provider/order_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cart = Provider.of<CartProvider>(context);
    final _items = _cart.items.values.toList();
    final bool _carrinhoVazio = _items.length == 0;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Carrinho",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: _carrinhoVazio
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
                        CartButton(cart: _cart),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (ctx, index) => CartItemWidget(_items[index]),
                  ),
                ),
              ],
            ),
    );
  }
}

class CartButton extends StatefulWidget {
  CartButton({
    super.key,
    required this.cart,
  });

  final CartProvider cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Future<void> handleBuy() async {
      setState(() => _isLoading = true);
      await Provider.of<OrderListProvider>(context, listen: false).addOrder(
        widget.cart,
      );
      widget.cart.clear();
      setState(
        () => _isLoading = false,
      );
    }

    return _isLoading
        ? SizedBox(
            height: 26,
            width: 26,
            child: CircularProgressIndicator(strokeWidth: 3),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: handleBuy,
              child: Text(
                "COMPRAR",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }
}
