import 'dart:convert';
import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/shared/services/http_response.dart';
import 'package:appshop/shared/services/i_http_client.dart';
import 'package:http/http.dart' as http;

class HttpClientService implements IHttpClient {
  final String baseUrl;
  final AuthProvider auth;

  HttpClientService({
    required this.baseUrl,
    required this.auth,
  });

  Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final token = auth.token;

    final queryParams = {
      if (query != null) ...query.map((k, v) => MapEntry(k, v.toString())),
      if (token != null) 'auth': token,
    };

    return Uri.parse('$baseUrl$path.json').replace(
      queryParameters: queryParams,
    );
  }

  HttpResponse _handleResponse(http.Response response) {
    final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    final httpResponse = HttpResponse(
      data: data,
      statusCode: response.statusCode,
      headers: response.headers,
      statusMessage: response.reasonPhrase,
    );

    if (!httpResponse.isSuccess) {
      throw Exception('Erro HTTP: ${response.statusCode}');
    }

    return httpResponse;
  }

  @override
  Future<HttpResponse> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    final response = await http.get(
      _buildUri(path, queryParameters),
      headers: _defaultHeaders(),
    );

    return _handleResponse(response);
  }

  @override
  Future<HttpResponse> post(String path,
      {dynamic body, Map<String, dynamic>? queryParameters}) async {
    final response = await http.post(
      _buildUri(path, queryParameters),
      headers: _defaultHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  @override
  Future<HttpResponse> put(String path, {dynamic body}) async {
    final response = await http.put(
      _buildUri(path),
      headers: _defaultHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  @override
  Future<HttpResponse> patch(String path, {dynamic body}) async {
    final response = await http.patch(
      _buildUri(path),
      headers: _defaultHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  @override
  Future<HttpResponse> delete(String path, {dynamic body}) async {
    if (!path.contains('/')) {
      throw Exception('DELETE precisa de um ID no path');
    }

    final response = await http.delete(
      _buildUri(path),
      headers: _defaultHeaders(),
    );

    return _handleResponse(response);
  }
}
