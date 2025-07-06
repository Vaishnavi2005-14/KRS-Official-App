import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bgColor = Color(0xFF06142E);
const Color orangeColor = Color(0xFFE5A122);


class AppConstants {
  static const List<String> domains = [
    "Advanced Embedded",
    "IoT",
    "Robotics",
    "App Development",
    "Machine Learning",
    "Web Development",
    "Operations",
    "Marketing",
    "Content",
    "Graphic Designing",
    "Video Editing",
    "Photography",
  ];

  static const List<String> meetingTypes = [
    'Scrum',
    'Leads Only',
    'Domain-Specific',
    'Inter-Domain',
  ];

  static const String defaultMeetingType = 'Scrum';
  static const String defaultTitle = '';
  static const String defaultLink = '';
  static const List<String> defaultDomains = [];
}

class AppInputDecoration {
  static InputDecoration getInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.grey),
      filled: true,
      fillColor: Color(0xff06132A),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.withAlpha(128)),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.withAlpha(128)),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: orangeColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class AppTextStyles {
  static TextStyle get titleStyle => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: orangeColor,
    shadows: const [Shadow(blurRadius: 10, color: orangeColor)],
  );

  static TextStyle get labelStyle => GoogleFonts.poppins(color: orangeColor);

  static TextStyle get inputStyle => GoogleFonts.poppins(color: Colors.white);

  static TextStyle get buttonStyle => GoogleFonts.poppins(color: Colors.black);

  static TextStyle get domainStyle =>
      GoogleFonts.poppins(color: Colors.white, fontSize: 20);
}

class AppColors {
  static const Color orangeColor = Color(0xFFE5A122);
  static const Color bgColor = Color(0xFF06142E);
  static const Color cardColor = Color(0xff06132A);
  static const Color darkBgColor = Color(0xff040E1E);
}

class AppDimensions {
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  static const double smallPadding = 8.0;
}