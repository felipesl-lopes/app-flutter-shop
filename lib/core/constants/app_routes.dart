import 'package:appshop/features/auth/Pages/auth_or_home_page.dart';
import 'package:appshop/features/auth/Pages/auth_page.dart';
import 'package:appshop/features/cart/Pages/cart_page.dart';
import 'package:appshop/features/home/Pages/home_page.dart';
import 'package:appshop/features/manage_products/Pages/manage_product_form_page.dart';
import 'package:appshop/features/manage_products/Pages/manage_products_page.dart';
import 'package:appshop/features/order/Pages/orders_page.dart';
import 'package:appshop/features/product/widgets/product_detail_page.dart';
import 'package:appshop/features/profile/Pages/profile_page.dart';
import 'package:appshop/features/search/Pages/search_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const AUTH_OR_HOME = "/";
  static const AUTH_LOGIN = "/login";
  static const HOME = "/home";
  static const DETAILS_PRODUCT = "/details-product";
  static const CART = "/cart";
  static const ORDERS = "/orders";
  static const MANAGE_PRODUCTS = "/manage-products";
  static const MANAGE_PRODUCT_FORM = "/manage-product-form";
  static const PROFILE = "/profile";
  static const SEARCH_PRODUCT = "/search-product";

  static Map<String, WidgetBuilder> routes = {
    AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
    AppRoutes.AUTH_LOGIN: (ctx) => AuthLogin(),
    AppRoutes.HOME: (ctx) => HomePage(),
    AppRoutes.DETAILS_PRODUCT: (ctx) => ProductDetailPage(),
    AppRoutes.CART: (ctx) => CartPage(),
    AppRoutes.ORDERS: (ctx) => OrdersPage(),
    AppRoutes.MANAGE_PRODUCTS: (ctx) => ManageProductsPage(),
    AppRoutes.MANAGE_PRODUCT_FORM: (ctx) => ProductFormPage(),
    AppRoutes.PROFILE: (ctx) => ProfilePage(),
    AppRoutes.SEARCH_PRODUCT: (ctx) => SearchPage(),
  };
}
