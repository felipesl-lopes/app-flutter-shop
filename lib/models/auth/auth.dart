import 'dart:async';
import 'dart:convert';

import 'package:appshop/data/preferencies_values.dart';
import 'package:appshop/data/secure_storage.dart';
import 'package:appshop/exceptions/auth_exception.dart';
import 'package:appshop/models/user_model.dart';
import 'package:appshop/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
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

  Future<void> _authenticate(String email, String password, String urlFragment,
      {String? name}) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyB2S4rurD7248aMRdxhlpLjsYWsywe2qec";

    final Map<String, dynamic> authBody = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(authBody),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException();
    }

    final _urlResponse =
        "${Constants.USERS_URL}/${body['localId']}.json?auth=${body['idToken']}";

    final dbResponse = urlFragment != "signUp"
        ? await http.get(Uri.parse(_urlResponse))
        : await http.put(
            Uri.parse(_urlResponse),
            body: jsonEncode({
              "name": name,
              "phoneNumber": 0,
              "city": "",
              "country": "",
              "address": "",
              "birthDate": "",
              "avatarUrl": "",
            }),
          );

    if (dbResponse.statusCode >= 400) {
      throw AuthException();
    }

    final bool keepLogged = await _prefs.getKeepLogged();
    if (urlFragment == 'signInWithPassword' &&
        keepLogged &&
        response.statusCode == 200) {
      await _storage.saveCredentials(email, password);
    }

    if (dbResponse.body.isNotEmpty) {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );
    }

    final userData = jsonDecode(dbResponse.body);
    final user = UserModel.fromMap(userData);
    _user = user;

    _autoLogout();
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name) async {
    return _authenticate(email, password, "signUp", name: name);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
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

  void _autoLogout() {
    _clearLogoutTimer();
    final _timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: _timeToLogout ?? 0), logout);
  }
}
