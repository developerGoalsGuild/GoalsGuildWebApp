import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.svg', height: 40),
            const SizedBox(width: 12),
            const Text('Goals Guild'),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Cognito'),
          onPressed: () {
            // TODO: Implement Cognito Auth
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
    );
  }
}
