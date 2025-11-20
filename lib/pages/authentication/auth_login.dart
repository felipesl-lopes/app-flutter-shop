import 'package:appshop/components/auth_form.dart';
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                child: Text(
                  textAlign: TextAlign.center,
                  "Mobile\nShop",
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: "Anton",
                    letterSpacing: 2.0,
                    height: 1.2,
                    color: Colors.purple,
                  ),
                ),
              ),
              SizedBox(height: 36),
              AuthForm(),
            ],
          ),
        ),
      ),
    );
  }
}
