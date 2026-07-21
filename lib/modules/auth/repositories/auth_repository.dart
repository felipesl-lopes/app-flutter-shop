import 'dart:async';
import 'dart:convert';

import 'package:appshop/core/errors/auth_exception.dart';
import 'package:appshop/core/services/i_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  final IHttpClient client;

  AuthRepository(this.client);

  String get apiKey => dotenv.env['API_KEY'] ?? '';

  Future<Map<String, dynamic>> logar({
    required String email,
    required String password,
  }) async {
    debugPrint('[AuthRepository]: logar');

    try {
      final response = await client.post('auth/signin', body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode > 400) {
        throw Exception('');
      }

      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> registrar({
    required String email,
    required String password,
    required String name,
  }) async {
    debugPrint('[AuthRepository]: registrar');

    try {
      final response = await client.post('auth/signup', body: {
        'email': email,
        'password': password,
        'name': name,
      });

      if (response.statusCode > 400) {
        throw Exception('');
      }

      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
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
}
