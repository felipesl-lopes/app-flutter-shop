import 'package:appshop/core/models/cart_item_model.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/cart/Widgets/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of<CartProvider>(context);

    Future<bool?> showRemoveItemDialog() {
      return showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Remover"),
          content:
              Text("Deseja remover o produto ${cartItem.name} do carrinho?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text("Não"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .removeItem(cartItem.id);
                Navigator.of(ctx).pop(true);
              },
              child: Text("Sim"),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(cartItem.imageUrl),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${cartItem.name}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "Total: ${formatPrice(cartItem.price * cartItem.quantity)}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(formatPrice(cartItem.price)),
                      Row(
                        children: [
                          QuantityButton(
                            onTap: () => {
                              cartItem.quantity == 1
                                  ? showRemoveItemDialog()
                                  : cart.removerItem(cartItem)
                            },
                            icon: Icons.remove,
                          ),
                          Container(
                            child: Text(
                              cartItem.quantity.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            height: 28,
                            width: 40,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          QuantityButton(
                              onTap: () => cart.addItem(cartItem),
                              icon: Icons.add),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
