import 'package:appshop/features/auth/Widgets/auth_form.dart';
import 'package:flutter/material.dart';

class AuthLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/teste-logo.png',
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              SizedBox(height: 28),
              AuthForm(),
            ],
          ),
        ),
      ),
    );
  }
}
