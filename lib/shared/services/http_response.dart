class HttpResponse {
  HttpResponse({
    this.data,
    this.headers,
    required this.statusCode,
    this.statusMessage,
  });

  final dynamic data;
  final Map<String, dynamic>? headers;
  final int statusCode;
  final String? statusMessage;

  HttpResponse copyWith({
    dynamicdata,
    Map<String, dynamic>? headers,
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
