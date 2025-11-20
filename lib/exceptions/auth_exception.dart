class AuthException implements Exception {
  static const Map<String, String> errors = {};

  @override
  String toString() {
    return "Por favor, verifique seu e-mail e sua senha e tente novamente.";
  }
}
