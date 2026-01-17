import 'package:appshop/shared/Widgets/image_fallback_icon.dart';
import 'package:flutter/material.dart';

class ImageAvatar extends StatelessWidget {
  final String? imageUrl;

  const ImageAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(40),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: SizedBox(
          width: 44,
          height: 44,
          child: hasImage
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return ImageFallbackIcon(size: 24);
                  },
                )
              : ImageFallbackIcon(size: 24),
        ),
      ),
    );
  }
}
