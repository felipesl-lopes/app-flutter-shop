class GenericExeption implements Exception {
  final String msg;
  final int statusCode;

  GenericExeption.ExceptionMsg({required this.msg, required this.statusCode});

  @override
  String toString() {
    return msg;
  }
}
