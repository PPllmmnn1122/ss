// نستورد الحزم اللي نحتاجها

import 'package:flutter/material.dart';
import 'package:my_special_needs_app/screens/widget/sign_language_keyboard.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'normal_person_screen.dart';

// تعريف شاشة لذوي الاحتياجات الخاصة

class SpecialNeedScreen extends StatefulWidget {
  const SpecialNeedScreen({super.key});

  @override
  _SpecialNeedScreenState createState() => _SpecialNeedScreenState();
}

class _SpecialNeedScreenState extends State<SpecialNeedScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showCustomKeyboard = false;
  late stt.SpeechToText _speech;
  Timer? _timer;
  String _displayedText = '';
  Timer? _deleteTimer;
  // نسوي الإعدادات الأولية لما يشتغل التطبيق

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showCustomKeyboard = true;
        });
      }
    });
  }

  // ننظف الموارد لما نقفل الشاشة

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    _deleteTimer?.cancel();
    super.dispose();
  }

  // لما يضغط المستخدم على حرف، نضيفه للنص

  void _handleKeyPressed(String letter) {
    setState(() {
      _controller.text += letter;
    });
  }
  // لما يضغط على زر الحذف، نحذف آخر حرف

  void _handleDeletePressed() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _controller.text =
            _controller.text.substring(0, _controller.text.length - 1);
      }
    });
  }

  void _handleDeleteLongPressed() {
    // Start a timer to repeatedly delete one letter at a time
    _deleteTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (_controller.text.isNotEmpty) {
          _controller.text =
              _controller.text.substring(0, _controller.text.length - 1);
        } else {
          _deleteTimer
              ?.cancel(); // Stop timer if there's nothing left to delete
        }
      });
    });
  }

  void _stopDeleteLongPress() {
    _deleteTimer?.cancel();
  }

  // نرسل النص ونعرضه، ونفرغ حقل الإدخال

  void _sendText() {
    setState(() {
      _displayedText = _controller.text;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 202, 221, 255),
      

appBar: AppBar(
  title: const Text(
    'شاشة لغة الإشارة',
    style: TextStyle(
      fontFamily: 'Cairo',
      color: Colors.white, // لون الخط أبيض
    ),
  ),
  backgroundColor: const Color.fromARGB(255, 84, 121, 247),
  actions: [
    IconButton(
  icon: const Icon(
    Icons.switch_left,
    color: Color.fromARGB(255, 255, 255, 255), // لون الأيقونة أبيض
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NormalPersonScreen()),
    );
  },
),
  ],
),


        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  //خط الكيبورد ذوي 
Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0), // إذا كنت ترغب في زوايا دائرية
    ),
    child: Center( // هنا نستخدم Center لجعل النص في الوسط
      child: Padding(
        padding: const EdgeInsets.all(8.0), // padding داخل الحدود
        child: Text(
          _displayedText,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 55,
                color: Color.fromARGB(95, 255, 124, 1),
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),
                  // Fixed image
                  Image.asset(
                    // صورة ثابتة
                    'images/ioo.png',
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            // حقل النص وزر الإرسال

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    children: [

                      Expanded(
  child: TextField(
    focusNode: _focusNode,
    controller: _controller,
    readOnly: true,
    style: const TextStyle(
      color: Color.fromARGB(255, 0, 0, 0), // لون نص الإدخال
    ),
    decoration: InputDecoration(
      hintText: 'اكتب اي شيء ...',
      hintStyle: const TextStyle(
        color: Color.fromARGB(255, 0, 0, 0), // لون نص التلميح
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 84, 121, 247), // لون الحدود البرتقالية
          width: 2, // سمك الحدود
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 84, 121, 247), // لون الحدود البرتقالية
          width: 2, // سمك الحدود
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 84, 121, 247), // لون الحدود البرتقالية
          width: 1, // سمك الحدود
        ),
      ),
      filled: true,
      fillColor: const Color.fromARGB(204, 255, 255, 255), // لون الخلفية
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
  ),
),



                     IconButton(
  icon: Container(
    width: 55, // عرض الزر
    height: 60, // ارتفاع الزر
    decoration: BoxDecoration(
      shape: BoxShape.circle, // جعل الشكل دائري
      color: const Color.fromARGB(255, 255, 255, 255), // لون الخلفية
      border: Border.all(
        color: const Color.fromARGB(255, 84, 121, 247), // لون الحدود البرتقالية
        width: 2, // سمك الحدود
      ),
    ),
    child: const Icon(
      Icons.send, // أيقونة الإرسال
      size: 25, // حجم الأيقونة
      color: Color.fromARGB(255, 84, 121, 247), // لون الأيقونة مثل WhatsApp
    ),
  ),
  onPressed: _sendText,
),
                    ],
                  ),
                ],
              ),
            ),
            // لوحة المفاتيح المخصصة تظهر إذا كان حقل النص مفعل

            if (_showCustomKeyboard)
              SizedBox(
                height: 300,
                child: SignLanguageKeyboard(
                  onKeyPressed: _handleKeyPressed,
                  onDeletePressed: _handleDeletePressed,
                  onDeleteLongPressed: _handleDeleteLongPressed,
                  stopDeleteLongPress: _stopDeleteLongPress,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
