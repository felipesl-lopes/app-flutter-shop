import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final String _title;
  final void Function()? _onPressed;
  final bool? secondaryButton;
  final Color? color;

  SendButton(
    this._title,
    this._onPressed, {
    this.secondaryButton = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: _onPressed,
      child: Text(_title,
          style: TextStyle(
              color: secondaryButton!
                  ? colorScheme.primary
                  : colorScheme.onPrimary,
              fontSize: 16)),
      style: ElevatedButton.styleFrom(
          backgroundColor: secondaryButton!
              ? null
              : color == null
                  ? colorScheme.primary
                  : color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: secondaryButton!
                  ? BorderSide(width: 2, color: colorScheme.primary)
                  : BorderSide.none),
          elevation: secondaryButton! ? 0 : null),
    );
  }
}
