import 'package:appshop/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ImageFallbackIcon extends StatelessWidget {
  final double size;

  ImageFallbackIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.image_not_supported,
      color: AppColors.grey,
      size: size,
    );
  }
}
