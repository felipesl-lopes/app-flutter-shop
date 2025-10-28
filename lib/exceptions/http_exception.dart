class HttpExceptionMsg implements Exception {
  final String msg;
  final int statusCode;

  HttpExceptionMsg({required this.msg, required this.statusCode});

  @override
  String toString() {
    return msg;
  }
}
