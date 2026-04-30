import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/auth/Repository/auth_repository.dart';
import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Repository/cart_repository.dart';
import 'package:appshop/modules/categorias/Provider/categorias_provider.dart';
import 'package:appshop/modules/categorias/Repository/categorias_repository.dart';
import 'package:appshop/modules/compras/Provider/order_list_provider.dart';
import 'package:appshop/modules/compras/Repository/order_repository.dart';
import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/modules/product/Repository/product_repository.dart';
import 'package:appshop/shared/repository/banners_provider.dart';
import 'package:appshop/shared/services/http_client_service.dart';
import 'package:appshop/shared/services/i_http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
String get apiurl => dotenv.env['API_URL'] ?? '';

void configureDependencies() {
  getIt.registerLazySingleton<IHttpClient>(
    () => HttpClientService(
      baseUrl: apiurl,
      getToken: () => getIt<AuthProvider>().token,
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<IHttpClient>()),
  );

  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(getIt<AuthRepository>()),
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
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepository(getIt<IHttpClient>()),
  );

  getIt.registerLazySingleton<CartProvider>(() => CartProvider(
        getIt<AuthProvider>(),
        getIt<CartRepository>(),
        getIt<ProductProvider>(),
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
        getIt<OrderRepository>(),
      ));

  getIt.registerLazySingleton<BannersProvider>(() => BannersProvider(
        getIt<AuthProvider>(),
        getIt<IHttpClient>(),
      ));
}
