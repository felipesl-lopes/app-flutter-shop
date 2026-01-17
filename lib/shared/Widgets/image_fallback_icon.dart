import 'package:flutter/material.dart';

class ImageFallbackIcon extends StatelessWidget {
  final double size;

  ImageFallbackIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.image_not_supported,
      color: Colors.grey,
      size: size,
    );
  }
}
