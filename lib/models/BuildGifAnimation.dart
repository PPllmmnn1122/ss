import 'package:flutter/material.dart';
import 'package:gifx/gifx.dart';

class BuildGifAnimation extends StatefulWidget {
  final String gifUrl; // مسار الـ GIF الذي سيتم تمريره
  final Key gifKey; // مفتاح فريد لضمان إعادة بناء الويدجت

  const BuildGifAnimation({required this.gifUrl, required this.gifKey})
      : super(key: gifKey);

  @override
  _BuildGifAnimationState createState() => _BuildGifAnimationState();
}

class _BuildGifAnimationState extends State<BuildGifAnimation> {
  late GifController _controller;

  @override
  void initState() {
    super.initState();
    // تهيئة الـ controller
    _controller = GifController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Gif.network(
      widget.gifUrl,
      controller: _controller,
      fit: BoxFit.cover,
    );
  }
}
