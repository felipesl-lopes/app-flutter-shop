import 'package:flutter/material.dart';

class AppAlert {
  static Future<void> showError(
    BuildContext context, {
    String title = "Ocorreu um erro",
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message.toString().replaceAll('Exception:', '').trim()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
