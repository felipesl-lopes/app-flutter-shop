import 'package:appshop/features/auth/Provider/auth_provider.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/order/Provider/order_list_provider.dart';
import 'package:appshop/features/product/Provider/product_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProxyProvider<AuthProvider, ProductListProvider>(
      create: (_) => ProductListProvider(),
      update: (ctx, auth, previous) {
        if (!auth.isAuth) {
          return ProductListProvider();
        }

        return ProductListProvider(
          auth.token ?? "",
          auth.userId ?? "",
          previous?.items ?? [],
        );
      },
    ),
    ChangeNotifierProxyProvider<AuthProvider, OrderListProvider>(
      create: (_) => OrderListProvider(),
      update: (ctx, auth, previous) {
        if (!auth.isAuth) {
          return OrderListProvider();
        }

        return OrderListProvider(
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
