import 'package:flutter/material.dart';

class OutlinedTextProvider with ChangeNotifier {
  String _text;
  double _fontSize;
  Color _textColor;
  Color _outlineColor;

  OutlinedTextProvider({
    String text = 'Glowing Text',
    double fontSize = 40.0,
    Color textColor = const Color(0xff353535),
    Color outlineColor = const Color(0xffE5A122),
  }) : _text = text,
       _fontSize = fontSize,
       _textColor = textColor,
       _outlineColor = outlineColor;

  String get text => _text;
  double get fontSize => _fontSize;
  Color get textColor => _textColor;
  Color get outlineColor => _outlineColor;

  set text(String value) {
    _text = value;
    notifyListeners();
  }

  set fontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  set textColor(Color value) {
    _textColor = value;
    notifyListeners();
  }

  set outlineColor(Color value) {
    _outlineColor = value;
    notifyListeners();
  }
}

Widget outlinedText({
  required String text,
  required double fontSize,
  required Color textColor,
  required Color outlineColor,
}) {
  return ClipRect(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            height: 1.2,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2.5
                  ..color = outlineColor,
            shadows: [
              Shadow(
                color: outlineColor.withAlpha(230),
                blurRadius: 15,
                offset: Offset(0, 0),
              ),
              Shadow(
                color: outlineColor.withAlpha(180),
                blurRadius: 25,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            height: 1.2,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}
