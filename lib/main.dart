import 'package:appshop/models/auth/auth.dart';
import 'package:appshop/models/cart.dart';
import 'package:appshop/models/order_list.dart';
import 'package:appshop/models/product_list.dart';
import 'package:appshop/pages/auth_or_home_page.dart';
import 'package:appshop/pages/authentication/auth_page.dart';
import 'package:appshop/pages/cart_page.dart';
import 'package:appshop/pages/orders_page.dart';
import 'package:appshop/pages/product_detail.dart';
import 'package:appshop/pages/product_form_page.dart';
import 'package:appshop/pages/products_overview.dart';
import 'package:appshop/pages/products_page.dart';
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
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
                auth.token ?? "", auth.userId ?? "", previous?.items ?? []);
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
                auth.token ?? "", auth.userId ?? "", previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: "Shopp",
        theme: ThemeData(primarySwatch: Colors.purple, fontFamily: "Lato"),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          AppRoutes.AUTH_LOGIN: (ctx) => AuthLogin(),
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
