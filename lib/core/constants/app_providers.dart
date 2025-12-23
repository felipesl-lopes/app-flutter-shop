import 'package:appshop/features/auth/Provider/auth.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/order/Provider/order_list.dart';
import 'package:appshop/features/product/Provider/product_list.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => Auth(),
    ),
    ChangeNotifierProxyProvider<Auth, ProductList>(
      create: (_) => ProductList(),
      update: (ctx, auth, previous) {
        if (!auth.isAuth) {
          return ProductList();
        }

        return ProductList(
          auth.token ?? "",
          auth.userId ?? "",
          previous?.items ?? [],
        );
      },
    ),
    ChangeNotifierProxyProvider<Auth, OrderList>(
      create: (_) => OrderList(),
      update: (ctx, auth, previous) {
        if (!auth.isAuth) {
          return OrderList();
        }

        return OrderList(
          auth.token ?? "",
          auth.userId ?? "",
          previous?.items ?? [],
        );
      },
    ),
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
    ),
  ];
}
