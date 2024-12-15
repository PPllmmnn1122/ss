import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../models/BuildGifAnimation.dart';
import 'special_need_screen.dart';

class NormalPersonScreen extends StatefulWidget {
  const NormalPersonScreen({super.key});

  @override
  _NormalPersonScreenState createState() => _NormalPersonScreenState();
}

class _NormalPersonScreenState extends State<NormalPersonScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late stt.SpeechToText _speech;
  final bool _isListening = false;
  Timer? _timer;
  int _recordDuration = 0;

  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? _filePath;
  bool _isRecording = false;
  List<String>? _displayedGifs;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();

    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await _recorder!.openRecorder();
    await _player!.openPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    _recorder!.closeRecorder();
    _player!.closePlayer();
    super.dispose();
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    _filePath = '${tempDir.path}/flutter_sound.aac';
    await _recorder!.startRecorder(toFile: _filePath);
    setState(() {
      _isRecording = true;
      _recordDuration = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });
    });

  }





//تحويل الصوت الى نص 

  Future<void> _stopRecordingAndConvertToText() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    _timer?.cancel();

    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      _speech.listen(
        onResult: (val) => setState(() {
          _controller.text = val.recognizedWords;
        }),
        localeId: "ar_SA",
      );
    }
  }







//تحويل النص الى GIF
  void _sendText() {
    String inputText = _controller.text.trim();

    if (textToGifMap.containsKey(inputText)) {
      setState(() {
        _displayedGifs = [textToGifMap[inputText]!];
      });
    } else {
      List<String> gifPaths = _getGifPaths(inputText);
      setState(() {
        _displayedGifs = gifPaths;
      });
    }
  }

  List<String> _getGifPaths(String inputText) {
    List<String> gifPaths = [];
    for (var letter in inputText.split('')) {
      gifPaths.add(textToGifMap[letter] ?? '');
    }
    return gifPaths;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 202, 221, 255),
        appBar: AppBar(
          title: const Text(
            'شاشة الشخص الطبيعي',
           style: TextStyle(
      fontFamily: 'Cairo',
      color: Colors.white, // لون الخط أبيض
    ),
  ),
          backgroundColor: const Color.fromARGB(255, 84, 121, 247),
          actions: [
            IconButton(
              icon: const Icon(Icons.switch_right),
              color: Color.fromARGB(255, 255, 255, 255), // لون الأيقونة أبيض
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpecialNeedScreen()),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _controller.text,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black38,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),



                  //تقسيم الصور 
                  if (_displayedGifs != null && _displayedGifs!.isNotEmpty)
                    _displayedGifs!.length == 1
                        ? Column(
                            children: [
                              BuildGifAnimation(
                                gifUrl: _displayedGifs![0],
                                gifKey: UniqueKey(),
                              ),
                            ],
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 3 / 4,
                            ),
                            itemCount: _displayedGifs!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [



                                  //تقسيم الحروف
                                  Text(
                                    _controller.text.split('')[index],
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 3.0,
                                          color: Colors.black38,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: BuildGifAnimation(
                                      gifUrl: _displayedGifs![index],
                                      gifKey: UniqueKey(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                children: [
                  Row(
                    children: [
                     Expanded(
  child: TextField(
    controller: _controller,
    // إزالة خاصية readOnly للسماح بالكتابة
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
          color: Color.fromARGB(255, 0, 102, 255), // اللون البرتقالي للإطار
          width: 3, // سمك الحدود
        ),
      ),
      filled: true,
      fillColor: Colors.white, // لون خلفية الإدخال
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
  ),
),

Stack(
  alignment: Alignment.center,
  children: [
    
    GestureDetector(
      onLongPress: _startRecording, // بدء التسجيل عند الضغط الطويل
      onLongPressUp: _stopRecordingAndConvertToText, // إيقاف التسجيل عند رفع الإصبع
      child: Container(
       width: 55, // عرض الزر
    height: 60, // ارتفاع الزر
        decoration: BoxDecoration(
          shape: BoxShape.circle, // جعل الشكل دائري
          color: const Color.fromARGB(255, 255, 255, 255), // لون الخلفية
          border: Border.all(
            color: const Color.fromARGB(255, 84, 121, 247), // لون الحدود
            width: 2.2, // سمك الحدود
          ),
        ),
        child: Icon(
          _isRecording ? Icons.mic : Icons.mic_none, // تغيير الأيقونة حسب حالة التسجيل
          color: _isRecording
              ? const Color.fromARGB(255, 81, 83, 156)
              : const Color.fromARGB(255, 84, 121, 247), // تغيير اللون حسب حالة التسجيل
          size: 25, // حجم الأيقونة
        ),
      ),
    ),
    if (_isRecording)
      Positioned(
        right: -5, // تغيير القيمة لإزاحة النص قليلاً إلى اليسار
        bottom: 5,
        child: Text(
          '$_recordDuration', // مدة التسجيل
          style: const TextStyle(color: Color.fromRGBO(110, 81, 255, 0.392)),
        ),
      ),
  ],
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
          ],
        ),
      ),
    );
  }
}
