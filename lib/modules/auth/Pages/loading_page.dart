import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.38,
            ),
            SizedBox(height: 28),
            SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(color: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
}
