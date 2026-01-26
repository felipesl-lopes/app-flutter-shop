import 'package:flutter/material.dart';

class IsOfflinePage extends StatelessWidget {
  const IsOfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sem internet",
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.wifi_off,
                  size: 39,
                  color: Colors.grey,
                ),
              ),
              Text("Verifique sua conexão e tente novamente."),
            ],
          ),
        ),
      ),
    );
  }
}
