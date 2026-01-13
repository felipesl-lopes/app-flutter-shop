import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/cart/Widgets/cart_item_widget.dart';
import 'package:appshop/features/order/Provider/order_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of<CartProvider>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Carrinho",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Column(
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
                    formatPrice(cart.totalAmount),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  CartButton(cart: cart)
                ],
              ),
            ),
          ),
          if (items.length == 0)
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.remove_shopping_cart,
                          color: Colors.black45, size: 60),
                      SizedBox(height: 16),
                      Text(
                        textAlign: TextAlign.center,
                        "Nenhum item encontrado no carrinho.",
                        style: TextStyle(color: Colors.black45, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Começe a comprar"),
                ),
              ],
            ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, index) => CartItemWidget(
                items[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
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
              color: widget.cart.itemsCount == 0
                  ? Colors.grey.withOpacity(0.6)
                  : Colors.purple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: widget.cart.itemsCount == 0 ? null : handleBuy,
              child: Text(
                "COMPRAR",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }
}
