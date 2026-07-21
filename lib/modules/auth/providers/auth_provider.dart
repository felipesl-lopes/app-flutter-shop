import 'dart:async';
import 'dart:convert';

import 'package:appshop/core/services/preferencies_values.dart';
import 'package:appshop/core/services/secure_storage.dart';
import 'package:appshop/modules/auth/models/user_model.dart';
import 'package:appshop/modules/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  String? _token;
  String? _refreshToken;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;
  final _prefs = PreferenciesValues();
  final _storage = SecureStorage();

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token => isAuth ? _token : null;
  String? get email => isAuth ? _email : null;
  String? get userId => isAuth ? _userId : null;

  UserModel? _user;
  UserModel? get user => _user;

  Future<void> registrar(String email, String password, String name) async {
    final body = await _repository.registrar(
        name: name, email: email, password: password);

    _token = body['accessToken'];
    _refreshToken = body['refreshToken'];
    _email = email;
    _expiryDate = DateTime.now().add(Duration(seconds: body['expiresIn']));

    _user = UserModel.fromMap(Map<String, dynamic>.from(body['user']));

    _generateNewToken();
    notifyListeners();
  }

  Future<void> logar(String email, String password) async {
    final body = await _repository.logar(email: email, password: password);

    final bool keepLogged = await _prefs.getKeepLogged();

    if (keepLogged) {
      await _storage.saveCredentials(email, password);
    }

    _token = body['accessToken'];
    _refreshToken = body['refreshToken'];
    _email = email;
    _expiryDate = DateTime.now().add(Duration(seconds: body['expiresIn']));

    _user = UserModel.fromMap(Map<String, dynamic>.from(body['user']));

    _generateNewToken();
    notifyListeners();
  }

  Future<void> deslogar() async {
    _refreshToken = null;
    _user = null;
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    await _prefs.deleteKeepLogged();
    await _storage.deleteCredentials();
    _clearLogoutTimer();
    notifyListeners();
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _generateNewToken() {
    _clearLogoutTimer();

    final secondsToExpiry =
        _expiryDate?.difference(DateTime.now()).inSeconds ?? 0;

    _logoutTimer = Timer(
      Duration(seconds: secondsToExpiry),
      refreshAuthToken,
    );
  }

  Future<void> refreshAuthToken() async {
    if (_refreshToken == null) {
      await deslogar();
      return;
    }

    try {
      final body = await _repository.refreshToken(refreshToken: _refreshToken!);

      _token = body['id_token'];
      _refreshToken = body['refresh_token'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expires_in'])),
      );

      await _storage.saveRefreshToken(jsonEncode(_refreshToken));

      _generateNewToken();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      await deslogar();
      rethrow;
    }
  }
}
