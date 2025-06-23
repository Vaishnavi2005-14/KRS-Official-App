import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App Colors
const Color bgColor = Color(0xFF06142E);
const Color orangeColor = Color(0xFFE5A122);

// App Constants
class AppConstants {
  static const List<String> domains = [
    'Operations',
    'Marketing',
    'Content',
    'Video Editing',
    'Graphic Designing',
    'Photography',
    'App Development',
    'Web Development',
    'Machine Learning',
    'Embedded',
  ];

  static const List<String> meetingTypes = [
    'Scrum',
    'Leads Only',
    'Domain-Specific',
    'Inter-Domain'
  ];
}

// Reusable Input Decoration
class AppInputDecoration {
  static InputDecoration getInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: orangeColor),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: orangeColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: orangeColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// Reusable Text Styles
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
  
  static TextStyle get domainStyle => GoogleFonts.poppins(
  color: Colors.white,
  fontSize: 20, 
);
}