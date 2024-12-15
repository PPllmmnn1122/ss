import 'package:flutter/material.dart';
import 'package:my_special_needs_app/screens/home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });

    return const Scaffold(
      body: Center(
        child: Text('Welcome to Our App!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
