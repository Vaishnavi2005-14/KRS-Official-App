import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedLanguageText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? textStyle;
  final Duration typingSpeed;
  final Duration pauseDuration;

  const AnimatedLanguageText({
    super.key,
    required this.texts,
    this.textStyle,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.pauseDuration = const Duration(seconds: 2),
  });

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<AnimatedLanguageText> {
  int _currentTextIndex = 0;
  String _displayedText = "";
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    final fullText = widget.texts[_currentTextIndex];
    int charIndex = 0;

    _typingTimer = Timer.periodic(widget.typingSpeed, (timer) {
      if (charIndex < fullText.length) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _displayedText = fullText.substring(0, charIndex + 1);
        });
        charIndex++;
      } else {
        timer.cancel();
        Future.delayed(widget.pauseDuration, () {
          if (!mounted) return;
          setState(() {
            _displayedText = "";
            _currentTextIndex = (_currentTextIndex + 1) % widget.texts.length;
          });
          _startTyping();
        });
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Text(
      _displayedText,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: isTablet ? 17 : screenWidth * 0.038,
      ),
      textAlign: TextAlign.left,
    );
  }
}
