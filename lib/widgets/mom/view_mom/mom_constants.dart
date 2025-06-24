import 'package:flutter/material.dart';

class MoMConstants {
  static const Color primaryAccent = Color(0xFFE5A122);

  static const Color backgroundColor = Color(0xFF06142E);

  static const Color whiteText = Colors.white;
  static const Color greyText = Colors.white54;
  static const Color hintText = Colors.white60;


  static const List<String> meetTypes = [
    'Scrum',
    'Inter-Domain',
    'Leads Only',
    'Domain-Specific',
  ];

  static const List<String> domains = [
    'Operations',
    'Marketing',
    'Content',
    'Video Editing',
    'Graphic Designing',
    'Photography',
    'App Dev',
    'Web Dev',
    'Machine Learning',
    'Embedded',
  ];
}

class MoMTextStyles {
  static TextStyle appBarTitle(double width) => TextStyle(
    color: MoMConstants.primaryAccent,
    fontWeight: FontWeight.bold,
    fontSize: width * 0.07,
  );

  static const TextStyle emptyState = TextStyle(
    color: MoMConstants.greyText,
    fontSize: 16,
  );

  static const TextStyle searchInput = TextStyle(
    color: MoMConstants.primaryAccent,
  );

  static const TextStyle searchHint = TextStyle(color: MoMConstants.hintText);
}

class MoMLayout {
  // Calculate horizontal padding based on screen width
  static double horizontalPadding(double width) => width * 0.04;

  // Calculate vertical padding based on screen height
  static double verticalPadding(double height) => height * 0.015;

  // Calculate spacing between search bar and list
  static double searchSpacing(double height) => height * 0.02;

  // Search bar border radius
  static const double searchBorderRadius = 25.0;

  // Search bar border width
  static const double searchBorderWidth = 2.0;
}
