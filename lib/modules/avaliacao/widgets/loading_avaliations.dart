import 'package:flutter/material.dart';

class LoadingAvaliations extends StatelessWidget {
  const LoadingAvaliations();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 3)),
      ),
    );
  }
}
