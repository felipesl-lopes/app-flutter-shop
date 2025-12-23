import 'package:appshop/core/services/preferencies_values.dart';
import 'package:appshop/core/services/secure_storage.dart';
import 'package:appshop/features/auth/Pages/auth_page.dart';
import 'package:appshop/features/auth/Provider/auth.dart';
import 'package:appshop/features/home/Pages/home_page.dart';
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
    // final auth = context.read<Auth>();

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

    return Consumer<Auth>(
      builder: (ctx, auth, _) {
        return auth.isAuth ? HomePage() : AuthLogin();
      },
    );
  }
}
