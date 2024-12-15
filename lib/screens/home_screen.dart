import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_special_needs_app/screens/special_need_screen.dart';

import 'normal_person_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double boxSize =
        MediaQuery.of(context).size.width * 0.4; // Size for the square boxes

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5E9E9),
        appBar: AppBar(
          title: Text('الشاشة الرئيسية', style: GoogleFonts.cairo()),
          backgroundColor: const Color.fromARGB(255, 233, 122, 122),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'الدخول كـ:',
                style: GoogleFonts.cairo(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceBox(
                    size: boxSize,
                    text: 'شخص طبيعي',
                    icon: Icons.person,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NormalPersonScreen()));
                    },
                  ),
                  const SizedBox(width: 20),
                  ChoiceBox(
                    size: boxSize,
                    text: ' ذوي الاحتياجات الخاصة',
                    icon: Icons.accessible,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SpecialNeedScreen()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChoiceBox extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const ChoiceBox({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: GoogleFonts.cairo(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
