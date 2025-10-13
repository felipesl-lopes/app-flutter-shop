import 'package:appshop/models/cart.dart';
import 'package:appshop/models/order_list.dart';
import 'package:appshop/models/product_list.dart';
import 'package:appshop/pages/cart_page.dart';
import 'package:appshop/pages/orders_page.dart';
import 'package:appshop/pages/product_detail.dart';
import 'package:appshop/pages/product_form_page.dart';
import 'package:appshop/pages/products_page.dart';
import 'package:appshop/pages/products_overview.dart';
import 'package:appshop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        title: "Shopp",
        theme: ThemeData(primarySwatch: Colors.purple, fontFamily: "Lato"),
        home: ProductsOverview(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.HOME: (ctx) => ProductsOverview(),
          AppRoutes.DETAILS_PRODUCT: (ctx) => ProductDetail(),
          AppRoutes.CART: (ctx) => CartPage(),
          AppRoutes.ORDERS: (ctx) => OrdersPage(),
          AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
        },
      ),
    );
  }
}
