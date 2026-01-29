import 'dart:async';
import 'dart:convert';

import 'package:appshop/core/services/preferencies_values.dart';
import 'package:appshop/core/services/secure_storage.dart';
import 'package:appshop/features/auth/Repository/auth_repository.dart';
import 'package:appshop/features/auth/enum/auth_mode.dart';
import 'package:appshop/shared/Models/user_model.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;
  final _prefs = PreferenciesValues();
  final _storage = SecureStorage();
  final _repository = AuthRepository();

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token => isAuth ? _token : null;
  String? get email => isAuth ? _email : null;
  String? get userId => isAuth ? _userId : null;

  UserModel? _user;
  UserModel? get user => _user;

  Future<void> _authenticate(String email, String password, AuthMode mode,
      {String? name}) async {
    try {
      final authBody = {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      };

      final authData =
          await _repository.authenticate(mode: mode, authBody: authBody);

      final userJson = UserModel(
        name: name ?? '',
        phoneNumber: 0,
        city: '',
        country: '',
        address: '',
        birthDate: null,
        avatarUrl: '',
      );

      final userData = await _repository.fetchOrCreateUser(
        mode: mode,
        userId: authData['localId'],
        token: authData['idToken'],
        userMap: userJson.toMap(),
      );

      final bool keepLogged = await _prefs.getKeepLogged();
      if (mode == AuthMode.signIn && keepLogged) {
        await _storage.saveCredentials(email, password);
      }

      if (userData.isNotEmpty) {
        _refreshToken = authData['refreshToken'];
        _token = authData['idToken'];
        _email = authData['email'];
        _userId = authData['localId'];
        _expiryDate = DateTime.now().add(
          Duration(seconds: int.parse(authData['expiresIn'])),
        );
      }

      _user = UserModel.fromMap(userData);

      _generateNewToken();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    return _authenticate(email, password, AuthMode.signUp, name: name);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, AuthMode.signIn);
  }

  Future<void> logout() async {
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
      await logout();
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
      await logout();
      rethrow;
    }
  }
}
