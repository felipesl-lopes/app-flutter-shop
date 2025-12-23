import 'package:flutter/material.dart';

InputDecoration getInputDecoration(String label) {
  return InputDecoration(
    fillColor: Colors.white,
    filled: true,
    hintText: label,
    hintStyle: TextStyle(color: Colors.grey),
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
