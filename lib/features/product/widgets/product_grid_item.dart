import 'package:appshop/core/utils/snackbar_helper.dart';
import 'package:appshop/features/auth/Provider/auth_provider.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:appshop/features/product/actions/product_actions.dart';
import 'package:appshop/features/product/widgets/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    void _selectPage(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: product,
            child: ProductDetailPage(),
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
              onPressed: () async => await ProductActions.toggleFavoriteProduct(
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
