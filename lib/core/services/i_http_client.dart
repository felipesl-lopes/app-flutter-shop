import 'package:appshop/core/services/http_response.dart';

abstract interface class IHttpClient {
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool validateStatus = true,
  });

  Future<HttpResponse> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResponse> patch(
    String path, {
    dynamic body,
  });

  Future<HttpResponse> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool validateStatus = true,
  });

  Future<HttpResponse> postAbsolute(
    String url, {
    Object? body,
    Map<String, String>? headers,
  });

  Future<HttpResponse> delete(
    String path, {
    dynamic body,
  });
}
