import 'package:flutter/material.dart';

class ShowSnackbar {
  static void snackbarMessage({
    required BuildContext context,
    required String textMessage,
    VoidCallback? onTap,
    String? textButton,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 4),
        dismissDirection: DismissDirection.down,
        content: Row(
          children: [
            Expanded(child: Text(textMessage)),
            if (onTap != null)
              TextButton(
                  onPressed: onTap,
                  child: Text(
                    textButton!,
                    style: TextStyle(color: Colors.orangeAccent),
                  )),
          ],
        ),
      ),
    );
  }
}
