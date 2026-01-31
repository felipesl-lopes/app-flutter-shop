import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum FlushType { success, info, error, warning }

enum FlushPosition { bottom, top }

void showAppFlushbar(
  BuildContext context, {
  required String message,
  required FlushType type,
  FlushPosition position = FlushPosition.bottom,
}) {
  final Color bg;
  final IconData iconData;

  switch (type) {
    case FlushType.success:
      bg = Colors.green;
      iconData = Icons.check_circle;
      break;
    case FlushType.info:
      bg = Colors.blue;
      iconData = Icons.info_outline;
      break;
    case FlushType.warning:
      bg = Colors.amber;
      iconData = Icons.warning;
      break;
    case FlushType.error:
      bg = Colors.red;
      iconData = Icons.error;
      break;
  }

  Flushbar(
    flushbarPosition: position == FlushPosition.top
        ? FlushbarPosition.TOP
        : FlushbarPosition.BOTTOM,
    messageSize: 18,
    message: message,
    backgroundColor: bg,
    duration: Duration(seconds: 2),
    borderRadius: BorderRadius.circular(8),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    margin: EdgeInsets.all(12),
    icon: Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Icon(
        iconData,
        color: Colors.white,
        size: 28,
      ),
    ),
  ).show(context);
}
