import 'package:flutter/material.dart';

class FeedbackMessage extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? iconColor;

  const FeedbackMessage({
    super.key,
    required this.message,
    required this.icon,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 56,
            color: iconColor,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
