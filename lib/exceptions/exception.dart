class ExceptionMsg implements Exception {
  final String msg;
  final int statusCode;

  ExceptionMsg.ExceptionMsg({required this.msg, required this.statusCode});

  @override
  String toString() {
    return msg;
  }
}
