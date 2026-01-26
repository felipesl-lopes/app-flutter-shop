import 'dart:async';

import 'package:appshop/core/services/preferencies_values.dart';
import 'package:appshop/core/services/secure_storage.dart';
import 'package:appshop/features/auth/Pages/auth_page.dart';
import 'package:appshop/features/auth/Pages/is_offline_page.dart';
import 'package:appshop/features/auth/Pages/loading_page.dart';
import 'package:appshop/features/auth/Provider/auth_provider.dart';
import 'package:appshop/features/home/Pages/home_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatefulWidget {
  @override
  State<AuthOrHomePage> createState() => _AuthOrHomePageState();
}

class _AuthOrHomePageState extends State<AuthOrHomePage> {
  late StreamSubscription<ConnectivityResult> _connectivitySub;

  bool _isLoading = true;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _startConnectivityListener();
    _tryAuthLogin();
  }

  void _startConnectivityListener() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      final hasConnection = result != ConnectivityResult.none;

      if (hasConnection && _isOffline) {
        setState(() {
          _isOffline = false;
          _isLoading = true;
        });

        _tryAuthLogin();
      }
    });
  }

  Future<void> _tryAuthLogin() async {
    final result = await Connectivity().checkConnectivity();
    final online = result != ConnectivityResult.none;

    if (!online) {
      setState(() {
        _isLoading = false;
        _isOffline = true;
      });
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
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
  void dispose() {
    _connectivitySub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return LoadingPage();

    if (_isOffline) return IsOfflinePage();

    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) {
        return auth.isAuth ? HomePage() : AuthLogin();
      },
    );
  }
}
