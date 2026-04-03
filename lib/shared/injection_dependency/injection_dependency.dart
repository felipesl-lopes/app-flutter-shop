import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Repository/cart_repository.dart';
import 'package:appshop/modules/categorias/Provider/categorias_provider.dart';
import 'package:appshop/modules/categorias/Repository/categorias_repository.dart';
import 'package:appshop/modules/compras/Provider/order_list_provider.dart';
import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/modules/product/Repository/product_repository.dart';
import 'package:appshop/shared/repository/banners_provider.dart';
import 'package:appshop/shared/services/http_client_service.dart';
import 'package:appshop/shared/services/i_http_client.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton<AuthProvider>(() => AuthProvider());

  getIt.registerLazySingleton<IHttpClient>(
    () => HttpClientService(
      baseUrl: 'https://shop-df68d-default-rtdb.firebaseio.com/',
      auth: getIt<AuthProvider>(),
    ),
  );

  getIt.registerLazySingleton<CategoriasRepository>(
    () => CategoriasRepository(getIt<IHttpClient>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(getIt<IHttpClient>()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepository(getIt<IHttpClient>()),
  );

  getIt.registerLazySingleton<CartProvider>(() => CartProvider(
        getIt<AuthProvider>(),
        getIt<CartRepository>(),
      ));

  getIt.registerLazySingleton<ProductProvider>(() => ProductProvider(
        getIt<AuthProvider>(),
        getIt<ProductRepository>(),
      ));

  getIt.registerLazySingleton<CategoriasProvider>(() => CategoriasProvider(
        getIt<AuthProvider>(),
        getIt<CategoriasRepository>(),
      ));

  getIt.registerLazySingleton<OrderListProvider>(() => OrderListProvider(
        getIt<AuthProvider>(),
        getIt<CartRepository>(),
      ));

  getIt.registerLazySingleton<BannersProvider>(
      () => BannersProvider(getIt<AuthProvider>()));
}
