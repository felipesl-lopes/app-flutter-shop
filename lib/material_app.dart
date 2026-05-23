import 'package:appshop/shared/constants/app_routes.dart';
import 'package:flutter/material.dart';

class MaterialAppWidget extends StatelessWidget {
  const MaterialAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shopp",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: "Lato",
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
