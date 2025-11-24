import 'package:appshop/data/preferencies_values.dart';
import 'package:appshop/data/secure_storage.dart';
import 'package:appshop/models/auth/auth.dart';
import 'package:appshop/pages/authentication/auth_page.dart';
import 'package:appshop/pages/products_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatefulWidget {
  @override
  State<AuthOrHomePage> createState() => _AuthOrHomePageState();
}

class _AuthOrHomePageState extends State<AuthOrHomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tryAuthLogin();
  }

  Future<void> _tryAuthLogin() async {
    final auth = Provider.of<Auth>(context, listen: false);
    final storage = SecureStorage();
    final creds = await storage.getCredentials();
    final prefs = await PreferenciesValues();

    if (creds != null) {
      try {
        await auth.signIn(creds['email']!, creds['password']!);
      } catch (e) {
        print(e);
      }
    } else {
      await prefs.deleteKeepLogged();
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    if (_isLoading)
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/teste-logo.png',
                width: MediaQuery.of(context).size.width * 0.38,
              ),
              SizedBox(height: 28),
              SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(color: Colors.purple),
              ),
            ],
          ),
        ),
      );

    return auth.isAuth ? ProductsOverview() : AuthLogin();
  }
}
