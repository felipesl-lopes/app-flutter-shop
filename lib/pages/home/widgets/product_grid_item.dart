import 'package:appshop/models/auth/auth.dart';
import 'package:appshop/models/cart.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/pages/products/product_detail.dart';
import 'package:appshop/pages/products/product_ui_actions.dart';
import 'package:appshop/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context, listen: false);

    void _selectPage(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: product,
            child: ProductDetail(),
          ),
        ),
      );
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
              onPressed: () async =>
                  await ProductUiActions.toggleFavoriteProduct(
                      context, product, auth),
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
              SnackbarHelper.showAddToCartMessage(context, product.name,
                  () => cart.removeSingleItem(product.id));
            },
          ),
        ),
      ),
    );
  }
}
