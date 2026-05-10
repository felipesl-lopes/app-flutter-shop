import 'package:appshop/shared/constants/app_colors.dart';
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
    return ElevatedButton(
      onPressed: _onPressed,
      child: Text(_title,
          style: TextStyle(
              color: secondaryButton! ? AppColors.primary : AppColors.white,
              fontSize: 16)),
      style: ElevatedButton.styleFrom(
          backgroundColor: secondaryButton!
              ? null
              : color == null
                  ? AppColors.primary
                  : color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: secondaryButton!
                  ? BorderSide(width: 2, color: AppColors.primary)
                  : BorderSide.none),
          elevation: secondaryButton! ? 0 : null),
    );
  }
}
