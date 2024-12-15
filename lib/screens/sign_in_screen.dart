import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_special_needs_app/screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'normal_person_screen.dart';
import 'special_need_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  String _userType = 'normal';

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تسجيل الدخول ناجح!')),
      );

      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        prefs.setBool('rememberMe', true);
        prefs.setString('email', _emailController.text);
        prefs.setString('password', _passwordController.text);
        prefs.setString('userType', _userType);
      } else {
        prefs.remove('email');
        prefs.remove('password');
        prefs.setBool('rememberMe', false);
        prefs.remove('userType');
      }

      // Redirect based on user type
      if (_userType == 'normal') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NormalPersonScreen()),
        );
      } else if (_userType == 'special') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SpecialNeedScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'فشل تسجيل الدخول')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 202, 221, 255),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 75,
                    color: Color.fromARGB(255, 84, 121, 247),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'مرحبًا بعودتك!',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'أدخل بريدك الإلكتروني وكلمة المرور الخاصة بك',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'البريد الإلكتروني ',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'كلمة المرور',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false; // تحديث الحالة
                            });
                          },
                          activeColor:
                              const Color.fromARGB(255, 84, 121, 247), // لون التحديد النشط
                        ),
                        Text(
                          'تذكرني',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // Add radio buttons for user type selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: 'normal',
                          groupValue: _userType,
                          onChanged: (value) {
                            setState(() {
                              _userType = value!;
                            });
                          },
                          activeColor: const Color.fromARGB(255, 84, 121, 247),
                        ),
                        const Text(
                          'شخص طبيعي',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'special',
                          groupValue: _userType,
                          onChanged: (value) {
                            setState(() {
                              _userType = value!;
                            });
                          },
                          activeColor: const Color.fromARGB(255, 84, 121, 247),
                        ),
                        const Text(
                          'ذوي الاحتياجات الخاصة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _signIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 84, 121, 247),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'ليس لديك حساب؟ ',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'أشتراك',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: Color.fromARGB(255, 84, 121, 247),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Image.asset(
                //   'images/walkthrough_images/signin_screen_image.png',
                //   height: 200,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
