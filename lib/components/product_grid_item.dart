import 'package:appshop/exceptions/http_exception.dart';
import 'package:appshop/models/auth/auth.dart';
import 'package:appshop/models/cart.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final msg = ScaffoldMessenger.of(context);
    final auth = Provider.of<Auth>(context, listen: false);

    void _selectPage(BuildContext context) {
      Navigator.of(context)
          .pushNamed(AppRoutes.DETAILS_PRODUCT, arguments: product);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: GridTile(
        child: GestureDetector(
            onTap: () => _selectPage(context),
            child: Image.network(product.imageUrl, fit: BoxFit.cover)),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.name, textAlign: TextAlign.center),
          leading: IconButton(
              onPressed: () async {
                try {
                  await product.toggleFavorite(auth.token ?? "", auth.userId ?? "", auth.email ?? "");
                } on HttpExceptionMsg catch (error) {
                  msg.showSnackBar(SnackBar(content: Text(error.toString())));
                }
                ;
              },
              icon: product.isFavorite
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : Icon(Icons.favorite_border)),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context)
                  .hideCurrentSnackBar(); // alerta apenas para o ultimo produto adicionado.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text("Produto ${product.name} adicionado ao carrinho!"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "DESFAZER",
                    textColor: Colors.orangeAccent,
                    onPressed: () => cart.removeSingleItem(product.id),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
