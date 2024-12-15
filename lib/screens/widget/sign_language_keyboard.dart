import 'package:flutter/material.dart';

class SignLanguageKeyboard extends StatefulWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onDeleteLongPressed;
  final VoidCallback stopDeleteLongPress;

  const SignLanguageKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onDeletePressed,
    required this.onDeleteLongPressed,
    required this.stopDeleteLongPress,
  });

  @override
  _SignLanguageKeyboardState createState() => _SignLanguageKeyboardState();
}

class _SignLanguageKeyboardState extends State<SignLanguageKeyboard> {
  final List<Map<String, String>> letterKeys = [
    {'label': 'ا', 'image': 'images/letters/0.jpg'},
    {'label': 'أ', 'image': 'images/letters/02.jpg'},
    {'label': 'إ', 'image': 'images/letters/03.jpg'},
    {'label': 'آ', 'image': 'images/letters/04.jpg'},
    {'label': 'ب', 'image': 'images/letters/1.jpg'},
    {'label': 'ت', 'image': 'images/letters/2.jpg'},
    {'label': 'ث', 'image': 'images/letters/3.jpg'},
    {'label': 'ج', 'image': 'images/letters/4.jpg'},
    {'label': 'ح', 'image': 'images/letters/5.jpg'},
    {'label': 'خ', 'image': 'images/letters/6.jpg'},
    {'label': 'د', 'image': 'images/letters/7.jpg'},
    {'label': 'ذ', 'image': 'images/letters/8.jpg'},
    {'label': 'ر', 'image': 'images/letters/9.jpg'},
    {'label': 'ز', 'image': 'images/letters/10.jpg'},
    {'label': 'س', 'image': 'images/letters/11.jpg'},
    {'label': 'ش', 'image': 'images/letters/12.jpg'},
    {'label': 'ص', 'image': 'images/letters/13.jpg'},
    {'label': 'ض', 'image': 'images/letters/14.jpg'},
    {'label': 'ط', 'image': 'images/letters/15.jpg'},
    {'label': 'ظ', 'image': 'images/letters/16.jpg'},
    {'label': 'ع', 'image': 'images/letters/17.jpg'},
    {'label': 'غ', 'image': 'images/letters/18.jpg'},
    {'label': 'ف', 'image': 'images/letters/19.jpg'},
    {'label': 'ق', 'image': 'images/letters/20.jpg'},
    {'label': 'ك', 'image': 'images/letters/21.jpg'},
    {'label': 'ل', 'image': 'images/letters/22.jpg'},
    {'label': 'م', 'image': 'images/letters/23.jpg'},
    {'label': 'ن', 'image': 'images/letters/24.jpg'},
    {'label': 'ه', 'image': 'images/letters/25.jpg'},
    {'label': 'و', 'image': 'images/letters/26.jpg'},
    {'label': 'ي', 'image': 'images/letters/27.jpg'},
    {'label': 'ة', 'image': 'images/letters/28.jpg'},
    {'label': 'ى', 'image': 'images/letters/37.jpg'},
    {'label': 'ئ', 'image': 'images/letters/36.jpg'},
    {'label': 'ؤ', 'image': 'images/letters/35.jpg'},
    {'label': 'لا', 'image': 'images/letters/29.jpg'},
    {'label': 'ء', 'image': 'images/letters/31.jpg'},
    {'label': 'ء', 'image': 'images/letters/30.jpg'},
  ];

  final List<Map<String, String>> numberKeys = [
    {'label': '0', 'image': 'images/numbers/zero.jpg'},
    {'label': '1', 'image': 'images/numbers/one.jpg'},
    {'label': '2', 'image': 'images/numbers/two.jpg'},
    {'label': '3', 'image': 'images/numbers/three.jpg'},
    {'label': '4', 'image': 'images/numbers/four.jpg'},
    {'label': '5', 'image': 'images/numbers/five.jpg'},
    {'label': '6', 'image': 'images/numbers/six.jpg'},
    {'label': '7', 'image': 'images/numbers/seven.jpg'},
    {'label': '8', 'image': 'images/numbers/eight.jpg'},
    {'label': '9', 'image': 'images/numbers/nine.jpg'},
    {'label': '9', 'image': 'images/numbers/nine.jpg'},
  ];

  bool _showLetters = true;

  void _toggleKeyboard() {
    setState(() {
      _showLetters = !_showLetters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          Expanded(
            child: _showLetters ? _buildLetterGrid() : _buildNumberGrid(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _toggleKeyboard,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 84, 121, 247),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                _showLetters ? 'أرقام' : 'أحرف',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterGrid() {
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      children: List.generate(letterKeys.length + 1, (index) {
        if (index == letterKeys.length) {
          return GestureDetector(
            onTap: () => widget.onDeletePressed(),
            onLongPress: () => widget.onDeleteLongPressed(),
            onLongPressEnd: (details) => widget.stopDeleteLongPress(),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.backspace,
                  size: 40,
                  color: Colors.red,
                ),
              ],
            ),
          );
        } else if (index == letterKeys.length - 1) {
          return GestureDetector(
            onTap: () => widget.onKeyPressed(" "),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1.0,
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => widget.onKeyPressed(letterKeys[index]['label']!),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1.0,
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    letterKeys[index]['image']!,
                    width: 45,
                    height: 45,
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildNumberGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      children: List.generate(numberKeys.length + 1, (index) {
        if (index == numberKeys.length) {
          return GestureDetector(
            onTap: () => widget.onDeletePressed(),
            onLongPress: () => widget.onDeleteLongPressed(),
            onLongPressEnd: (details) => widget.stopDeleteLongPress(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Center(
                child: Icon(Icons.backspace, size: 40, color: Colors.red),
              ),
            ),
          );
        } else if (index == numberKeys.length - 1) {
          return GestureDetector(
            onTap: () => widget.onKeyPressed(" "),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1.0,
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "Space",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => widget.onKeyPressed(numberKeys[index]['label']!),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1.0,
                      blurRadius: 2.0,
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    numberKeys[index]['image']!,
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}