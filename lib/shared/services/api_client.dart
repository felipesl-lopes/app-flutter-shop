import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String token;
  static const _baseUrl = 'https://shop-df68d-default-rtdb.firebaseio.com/';

  ApiClient(this.token);

  Uri _buildUri(String path, {Map<String, String>? queryParams}) {
    final params = {
      'auth': token,
      ...?queryParams,
    };

    return Uri.parse('$_baseUrl/$path.json').replace(queryParameters: params);
  }

  Future<http.Response> get(String path, {Map<String, String>? queryParams}) {
    return http.get(_buildUri(path, queryParams: queryParams));
  }

  Future<http.Response> post(String path, Object body) {
    return http.post(
      _buildUri(path),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(String path, Object body) {
    return http.patch(
      _buildUri(path),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path) {
    return http.delete(
      _buildUri(path),
    );
  }

  Future<http.Response> put(String path, Object body) {
    return http.put(
      _buildUri(path),
      body: jsonEncode(body),
    );
  }
}
