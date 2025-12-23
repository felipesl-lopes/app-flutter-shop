import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  Badgee({
    required this.child,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color ?? Colors.redAccent),
            child: Text(
              value,
              style: TextStyle(fontSize: 10, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            constraints: BoxConstraints(
              minHeight: 16,
              minWidth: 16,
            ),
          ),
        )
      ],
    );
  }
}
