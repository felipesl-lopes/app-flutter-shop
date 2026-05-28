import 'package:flutter/material.dart';

InputDecoration getInputDecoration(
  BuildContext context,
  String label, {
  bool? activityLabel = false,
  bool? activityHint = false,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return InputDecoration(
    fillColor: colorScheme.surface,
    filled: true,
    hintText: activityHint == true ? label : null,
    labelText: activityLabel == true ? label : null,
    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    errorStyle: TextStyle(
      fontSize: 14,
      height: 0,
    ),
  );
}
