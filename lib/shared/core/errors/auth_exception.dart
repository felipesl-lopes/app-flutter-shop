class AuthException implements Exception {
  final String? message;
  final String? code;

  AuthException({this.message, this.code});

  String get errorMessage {
    if (message != null && message!.isNotEmpty) {
      return message!;
    }

    return 'Erro de autenticação. Tente novamente.';
  }

  @override
  String toString() => errorMessage;
}
