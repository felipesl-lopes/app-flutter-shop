import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/categorias/Provider/categorias_provider.dart';
import 'package:appshop/modules/compras/Provider/order_list_provider.dart';
import 'package:appshop/modules/endereco/Provider/endereco_provider.dart';
import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/shared/injection_dependency/injection_dependency.dart';
import 'package:appshop/shared/repository/banners_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => getIt<AuthProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<CartProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<ProductProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<CategoriasProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<OrderListProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<BannersProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<EnderecoProvider>(),
    )
  ];
}
