import 'package:appshop/shared/constants/app_providers.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/injection_dependency/injection_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  configureDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: "Shopp",
        theme: ThemeData(primarySwatch: Colors.purple, fontFamily: "Lato"),
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
      ),
    );
  }
}
