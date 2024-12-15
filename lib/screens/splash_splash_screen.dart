import 'package:flutter/material.dart';
import 'package:my_special_needs_app/screens/sign_in_screen.dart';
import 'package:my_special_needs_app/screens/special_need_screen.dart';
import 'dart:async';
import 'normal_person_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'images/ioo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  final Future<String> Function() checkInitialScreen;

  const SplashScreenWrapper({super.key, required this.checkInitialScreen});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    try {
      String initialScreen = await widget.checkInitialScreen();
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) {
        return;
      }

      if (initialScreen == 'normal') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const NormalPersonScreen()));
      } else if (initialScreen == 'special') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SpecialNeedScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInScreen()));
      }
    } catch (e) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
