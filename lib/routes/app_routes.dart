import 'package:appshop/pages/authentication/auth_or_home_page.dart';
import 'package:appshop/pages/authentication/auth_page.dart';
import 'package:appshop/pages/cart/cart_page.dart';
import 'package:appshop/pages/home/home_page.dart';
import 'package:appshop/pages/orders/orders_page.dart';
import 'package:appshop/pages/products/product_detail.dart';
import 'package:appshop/pages/products/product_form_page.dart';
import 'package:appshop/pages/products/products_page.dart';
import 'package:appshop/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const AUTH_OR_HOME = "/";
  static const AUTH_LOGIN = "/login";
  static const HOME = "/home";
  static const DETAILS_PRODUCT = "/details-product";
  static const CART = "/cart";
  static const ORDERS = "/orders";
  static const PRODUCTS = "/products";
  static const PRODUCT_FORM = "/product-form";
  static const PROFILE = "/profile";

  static Map<String, WidgetBuilder> routes = {
    AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
    AppRoutes.AUTH_LOGIN: (ctx) => AuthLogin(),
    AppRoutes.HOME: (ctx) => HomePage(),
    AppRoutes.DETAILS_PRODUCT: (ctx) => ProductDetail(),
    AppRoutes.CART: (ctx) => CartPage(),
    AppRoutes.ORDERS: (ctx) => OrdersPage(),
    AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
    AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
    AppRoutes.PROFILE: (ctx) => ProfilePage(),
  };
}
