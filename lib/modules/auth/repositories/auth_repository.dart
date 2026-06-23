import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appshop/core/errors/auth_exception.dart';
import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/auth/enum/auth_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  final IHttpClient client;

  AuthRepository(this.client);

  String get apiKey => dotenv.env['API_KEY'] ?? '';

  Future<Map<String, dynamic>> autenticar({
    required AuthMode mode,
    required Map<String, dynamic> authBody,
  }) async {
    debugPrint('[AuthRepository]: autenticar');

    try {
      final endpoint = mode == AuthMode.signIn ? 'auth/signin' : 'auth/signup';

      final response = await client
          .post(endpoint, body: authBody)
          .timeout(const Duration(seconds: 10));

      final data = response.data;

      if (data is! Map) {
        throw AuthException();
      }

      final body = Map<String, dynamic>.from(data);

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
    debugPrint('[AuthRepository]: refreshToken');
    try {
      final response = await client.post('auth/refresh-token', body: {
        'refreshToken': refreshToken
      }).timeout(const Duration(seconds: 10));

      final data = response.data;

      final body =
          data is String ? jsonDecode(data) : Map<String, dynamic>.from(data);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AuthException();
      }

      return body;
    } catch (e) {
      debugPrint(e.toString());
      throw AuthException();
    }
  }

  Future<Map<String, dynamic>> fetchOrCreateUser({
    required AuthMode mode,
    required String userId,
    required String token,
    required Map<String, dynamic> userMap,
  }) async {
    debugPrint('[AuthRepository]: fetchOrCreateUser');
    try {
      final queryParameters = {'auth': token};

      final response = mode == AuthMode.signIn
          ? await client
              .get(
                'auth/$userId',
                queryParameters: queryParameters,
                validateStatus: false,
              )
              .timeout(const Duration(seconds: 10))
          : await client
              .put(
                'auth/$userId',
                body: userMap,
                queryParameters: queryParameters,
                validateStatus: false,
              )
              .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw AuthException();
      }

      final raw = response.data;

      if (raw == null || (raw is String && raw.isEmpty)) {
        return {};
      }

      if (raw is Map<String, dynamic>) {
        return raw;
      }

      if (raw is Map) {
        return Map<String, dynamic>.from(raw);
      }

      return {};
    } catch (e) {
      debugPrint(e.toString());
      throw AuthException();
    }
  }
}
