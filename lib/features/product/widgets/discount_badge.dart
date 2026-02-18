import 'package:flutter/material.dart';

class DiscountBadge extends StatelessWidget {
  final double percentage;
  final double fontSize;

  const DiscountBadge({
    required this.percentage,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "Oferta ${percentage.truncate()}%",
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
    );
  }
}
