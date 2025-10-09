import 'package:appshop/models/cart.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);

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
              onPressed: () {
                product.toggleFavorite();
              },
              icon: product.isFavorite
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : Icon(Icons.favorite_border)),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ),
      ),
    );
  }
}
