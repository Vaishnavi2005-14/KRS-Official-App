import 'package:flutter/material.dart';

// ============================================================================
// APP COLORS
// ============================================================================

class AppColors {
  static const Color bgColor = Color(0xFF06142E);
  static const Color orangeColor = Color(0xFFE5A122);

  // Additional colors for consistency
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color greyColor = Colors.grey;
  static const Color redColor = Colors.red;
  static const Color blueColor = Colors.blue;
}

// ============================================================================
// APP CONSTANTS
// ============================================================================

class AppConstants {
  // Domain options
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

  // Meeting type options
  static const List<String> meetingTypes = [
    'Leads-only',
    'Domain-Specific',
    'Inter-Domain',
    'Scrum',
  ];

  // Display names for meeting types
  static const Map<String, String> typeDisplayNames = {
    'Leads-only': 'Leads-Only',
    'Scrum': 'Scrum',
    'Domain-Specific': 'Domain-Specific',
    'Inter-Domain': 'Inter-Domain',
  };

  // Default values
  static const String defaultTitle = 'MoM heading';
  static const String defaultLink = 'enterlinkhere/clickable.com';
  static const String defaultMeetingType = 'Domain-Specific';
  static const List<String> defaultDomains = [
    'Operations',
    'Marketing',
    'Content',
  ];
}

// ============================================================================
// TEXT STYLES
// ============================================================================

class AppTextStyles {
  static const String fontFamily = 'Poppins';

  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    color: AppColors.orangeColor,
  );

  static const TextStyle labelStyle = TextStyle(
    color: AppColors.orangeColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
  );

  static const TextStyle inputStyle = TextStyle(
    color: AppColors.whiteColor,
    fontFamily: fontFamily,
  );

  static const TextStyle buttonStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  static const TextStyle checkboxStyle = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 14,
    fontFamily: fontFamily,
  );

  static const TextStyle snackBarStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );
}

// ============================================================================
// DIMENSIONS
// ============================================================================

class AppDimensions {
  // Padding and margins
  static const double defaultPadding = 20.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 30.0;
  static const double extraLargePadding = 40.0;

  // Border radius
  static const double defaultBorderRadius = 8.0;
  static const double buttonBorderRadius = 25.0;
  static const double checkboxBorderRadius = 3.0;

  // Icon and widget sizes
  static const double checkboxSize = 18.0;
  static const double checkIconSize = 12.0;
  static const double progressIndicatorSize = 20.0;
  static const double borderWidth = 2.0;

  // Button dimensions
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 40,
    vertical: 16,
  );
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
}
