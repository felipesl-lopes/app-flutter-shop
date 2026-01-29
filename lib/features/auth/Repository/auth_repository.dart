import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appshop/core/constants/url_config.dart';
import 'package:appshop/core/errors/auth_exception.dart';
import 'package:appshop/features/auth/enum/auth_mode.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<Map<String, dynamic>> authenticate({
    required AuthMode mode,
    required Map<String, dynamic> authBody,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(mode == AuthMode.signIn ? SIGNIN_URL : SIGNUP_URL),
            body: jsonEncode(authBody),
          )
          .timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body);

      if (body['error'] != null) {
        throw AuthException();
      }

      return body;
    } on SocketException {
      throw SocketException('Internet instável.');
    } on TimeoutException {
      throw TimeoutException('Tempo de espera excedido.');
    }
  }

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    final response = await http.post(
      Uri.parse(SECURE_TOKEN_URL),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    ).timeout(const Duration(seconds: 10));

    final body = jsonDecode(response.body);

    if (response.statusCode != 200 || body['error'] != null) {
      throw AuthException();
    }

    return body;
  }

  Future<Map<String, dynamic>> fetchOrCreateUser({
    required AuthMode mode,
    required String userId,
    required String token,
    required Map<String, dynamic> userMap,
  }) async {
    final url = "$USERS_BASE_URL/$userId.json?auth=$token";

    final response = mode == AuthMode.signIn
        ? await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10))
        : await http
            .put(
              Uri.parse(url),
              body: jsonEncode(userMap),
            )
            .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw AuthException();
    }

    if (response.body.isEmpty) return {};

    return jsonDecode(response.body);
  }
}
