import 'package:appshop/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

InputDecoration getInputDecoration(String label,
    {bool? activityLabel = false, bool? activityHint = false}) {
  return InputDecoration(
    fillColor: AppColors.white,
    filled: true,
    hintText: activityHint == true ? label : null,
    labelText: activityLabel == true ? label : null,
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: AppColors.grey),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    errorStyle: TextStyle(
      fontSize: 14,
      height: 0,
    ),
  );
}
