import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_special_needs_app/screens/normal_person_screen.dart';
import 'package:my_special_needs_app/screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_special_needs_app/screens/normal_person_screen.dart';
import 'package:my_special_needs_app/screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ASLApp());
}

class ASLApp extends StatelessWidget {
  const ASLApp({super.key});

  Future<String> _checkInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seen') ?? false;
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    String? userType = prefs.getString('userType');


    if (!seen) {
      return 'walkthrough';
    } else if (rememberMe && userType != null) {
      if (userType == 'normal') {
        return 'normal';
      } else if (userType == 'special') {
        return 'special';
      }
    }
    return 'signIn';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _checkInitialScreen(),
        builder: (context, snapshot) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Special Needs Communication App',
            home:SignInScreen(), // الشاشة التي تعرض بعد تحديد الشاشة الأولية
          );
        });
  }
}
