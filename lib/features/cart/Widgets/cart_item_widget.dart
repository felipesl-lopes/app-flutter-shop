import 'package:appshop/core/models/cart_item_model.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Excluir"),
            content:
                Text("Deseja excluir o produto ${cartItem.name} do carrinho?"),
            actions: [
              TextButton(
                child: Text("Não"),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text("Sim"),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<CartProvider>(context, listen: false)
            .removeItem(cartItem.id);
      },
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white, size: 26),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.fromLTRB(20, 0, 20, 12),
      ),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(cartItem.imageUrl),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cartItem.name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${cartItem.quantity.toString()}x"),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatPrice(cartItem.price)),
              Text("Total: ${formatPrice(cartItem.price * cartItem.quantity)}"),
            ],
          ),
        ),
      ),
    );
  }
}
