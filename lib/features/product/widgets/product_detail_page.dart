import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/core/utils/snackbar_helper.dart';
import 'package:appshop/features/auth/Provider/auth.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/product/Provider/product.dart';
import 'package:appshop/features/product/actions/product_actions.dart';
import 'package:appshop/shared/Widgets/badgee.dart';
import 'package:appshop/shared/Widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final auth = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<CartProvider>(context);

    void handleBuy() {
      cart.addItem(product);
      SnackbarHelper.showAddToCartMessage(
          context, product.name, () => cart.removeSingleItem(product.id));
      Navigator.of(context).pushNamed(AppRoutes.CART);
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          product.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        actions: [
          Consumer<CartProvider>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CART),
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                )),
            builder: (ctx, cart, child) => Badgee(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 22),
              Stack(
                children: [
                  Container(
                    height: 340,
                    width: 340,
                    child: Image.network(product.imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Color.fromRGBO(220, 220, 220, 0.4),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(60),
                          onTap: () async =>
                              await ProductActions.toggleFavoriteProduct(
                                  context, product, auth),
                          splashColor: Colors.redAccent.withOpacity(0.2),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Consumer<Product>(
                              builder: (ctx, product, _) => product.isFavorite
                                  ? Icon(Icons.favorite,
                                      color: Colors.redAccent)
                                  : Icon(Icons.favorite_border),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(formatPrice(product.price), style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Descrição:"),
                    Text(product.description),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: SendButton("Comprar agora", handleBuy),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  cart.addItem(product);
                  SnackbarHelper.showAddToCartMessage(context, product.name,
                      () => cart.removeSingleItem(product.id));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.purple),
                    SizedBox(width: 12),
                    Text("Adicionar ao carrinho",
                        style: TextStyle(color: Colors.purple)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
