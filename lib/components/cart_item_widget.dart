import 'package:appshop/models/cart.dart';
import 'package:appshop/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

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
        Provider.of<Cart>(context, listen: false)
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
          title: Text(cartItem.name),
          subtitle: Text(
              "Total: R\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}"),
          trailing: Text("${cartItem.quantity}x"),
        ),
      ),
    );
  }
}
