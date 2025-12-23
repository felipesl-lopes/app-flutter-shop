import 'package:flutter/material.dart';

String? isValidEmail(String email) {
  if (email.trim().isEmpty) {
    return "E-mail é obrigatório.";
  } else if (!email.trim().contains("@")) {
    return "E-mail inválido.";
  }
  return null;
}

String? isValidName(String name) {
  if (name.trim().isEmpty) {
    return "Nome é obrigatório.";
  } else if (name.trim().length < 4) {
    return "Nome muito curto.";
  }
  return null;
}

String? isValidPassword(String password, bool isSignup,
    TextEditingController senhaConfirmController) {
  if (password.trim().isEmpty) {
    return "Senha é obrigatória.";
  }
  if (password.trim().length < 6) {
    return "Mínimo de 6 dígitos.";
  }
  if (isSignup && password.trim() != senhaConfirmController.text) {
    return 'As senhas não coincidem.';
  }
  return null;
}

String? isValidPasswordConfirm(
    String password, bool isSignup, TextEditingController senhaController) {
  if (password.trim().isEmpty) {
    return "Senha é obrigatória.";
  }
  if (password.trim().length < 6) {
    return "Mínimo de 6 dígitos.";
  }
  if (isSignup && password.trim() != senhaController.text) {
    return 'As senhas não coincidem.';
  }
  return null;
}
