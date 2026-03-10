class HttpResponse {
  HttpResponse({
    this.data,
    this.headers,
    this.statusCode,
    this.statusMessage,
  });

  final dynamic data;
  final Map<String, dynamic>? headers;
  final int? statusCode;
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

  List<Object?> get props => [
        data,
        headers,
        statusCode,
        statusMessage,
      ];
}
