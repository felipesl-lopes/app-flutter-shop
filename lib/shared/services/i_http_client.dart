import 'dart:io';

enum CustomResponseType { json, stream, plain, bytes }

abstract interface class IHttpClient {
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration receiveTimeout = const Duration(seconds: 20),
    String? contentType,
    CustomResponseType? responseType,
  });

  Future<HttpResponse> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration receiveTimeout = const Duration(seconds: 20),
    String? contentType,
    CustomResponseType? responseType,
  });

  Future<HttpResponse> patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration receiveTimeout = const Duration(seconds: 20),
    String? contentType,
    CustomResponseType? responseType,
  });

  Future<HttpResponse> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration receiveTimeout = const Duration(seconds: 20),
    String? contentType,
    CustomResponseType? responseType,
  });

  Future<HttpResponse> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration receiveTimeout = const Duration(seconds: 20),
    String? contentType,
    CustomResponseType? responseType,
  });
}
