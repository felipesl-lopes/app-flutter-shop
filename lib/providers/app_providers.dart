import 'package:appshop/models/auth/auth.dart';
import 'package:appshop/models/cart.dart';
import 'package:appshop/models/order_list.dart';
import 'package:appshop/models/product_list.dart';
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
  ];
}
