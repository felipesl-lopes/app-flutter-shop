import 'package:appshop/core/constants/app_providers.dart';
import 'package:appshop/core/injection_dependency/injection_dependency.dart';
import 'package:appshop/material_app.dart';
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
      child: const MaterialAppWidget(),
    );
  }
}
