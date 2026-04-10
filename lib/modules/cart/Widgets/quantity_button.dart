import 'package:appshop/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const QuantityButton(
      {required this.onTap,
      this.color = AppColors.primary,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Icon(
          icon,
          color: AppColors.white,
          size: 20,
        ),
      ),
    );
  }
}
