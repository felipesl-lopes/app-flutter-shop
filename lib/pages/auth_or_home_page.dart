import 'package:appshop/models/auth/auth.dart';
import 'package:appshop/pages/authentication/auth_login.dart';
import 'package:appshop/pages/products_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    return auth.isAuth ? ProductsOverview() : AuthLogin();
  }
}
