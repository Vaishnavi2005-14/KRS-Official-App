import 'package:flutter/material.dart';

/// Color constants used throughout the MoM (Minutes of Meeting) feature
class MoMConstants {
  // Primary accent color - used for highlights, buttons, and borders
  static const Color primaryAccent = Color(0xFFE5A122);
  
  // Background color - main app background
  static const Color backgroundColor = Color(0xFF06142E);
  
  // Text colors
  static const Color whiteText = Colors.white;
  static const Color greyText = Colors.white54;
  static const Color hintText = Colors.white60;
}

/// Text styles used in MoM pages
class MoMTextStyles {
  // App bar title style - responsive based on screen width
  static TextStyle appBarTitle(double width) => TextStyle(
    color: MoMConstants.primaryAccent,
    fontWeight: FontWeight.bold,
    fontSize: width * 0.07,
  );
  
  // Empty state message style
  static const TextStyle emptyState = TextStyle(
    color: MoMConstants.greyText, 
    fontSize: 16
  );
  
  // Search input text style
  static const TextStyle searchInput = TextStyle(
    color: MoMConstants.primaryAccent
  );
  
  // Search hint text style
  static const TextStyle searchHint = TextStyle(
    color: MoMConstants.hintText
  );
}

/// Layout constants for consistent spacing
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