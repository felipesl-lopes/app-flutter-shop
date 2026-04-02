class HttpResponse {
  final dynamic data;
  final Map<String, String>? headers;
  final int statusCode;
  final String? statusMessage;

  HttpResponse({
    this.data,
    this.headers,
    required this.statusCode,
    this.statusMessage,
  });

  HttpResponse copyWith({
    dynamic data,
    Map<String, String>? headers,
    int? statusCode,
    String? statusMessage,
  }) {
    return HttpResponse(
      data: data ?? this.data,
      headers: headers ?? this.headers,
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  List<Object?> get props => [
        data,
        headers,
        statusCode,
        statusMessage,
      ];
}
