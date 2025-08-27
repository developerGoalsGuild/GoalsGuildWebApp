import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.svg', height: 40),
            SizedBox(width: 12),
            Text('Goals Guild'),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text('Sign in with Cognito'),
          onPressed: () {
            // TODO: Implement Cognito Auth
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
    );
  }
}
