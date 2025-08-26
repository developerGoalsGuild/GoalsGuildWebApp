import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login.dart';
import 'screens/home.dart';

void main() {
  runApp(GoalsGuildApp());
}

class GoalsGuildApp extends StatelessWidget {
  const GoalsGuildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goals Guild',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF7C4700),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4700),
          primary: const Color(0xFF7C4700),
          secondary: const Color(0xFFD4AF37),
        ),
        textTheme: GoogleFonts.medievalSharpTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5E9DA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7C4700),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: LoginScreen(),
      routes: {
        '/home': (_) => HomeScreen(),
      },
    );
  }
}
