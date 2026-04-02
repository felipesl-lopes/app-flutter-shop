import 'package:appshop/shared/services/http_response.dart';

abstract interface class IHttpClient {
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
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
  });

  Future<HttpResponse> delete(
    String path, {
    dynamic body,
  });
}
