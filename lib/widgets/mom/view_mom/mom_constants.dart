import 'package:flutter/material.dart';
import 'package:krs_app/widgets/mom/edit_mom/constants_file.dart';

class MoMConstants {
  static const Color primaryAccent = Color(0xFFE5A122);
  static const Color backgroundColor = Color(0xFF06142E);
  static const Color whiteText = Colors.white;
  static const Color greyText = Colors.white54;
  static const Color hintText = Colors.white60;

  static List<String> get meetTypes => AppConstants.meetingTypes;
  static List<String> get domains => AppConstants.domains;
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
  static double horizontalPadding(double width) => width * 0.04;
  static double verticalPadding(double height) => height * 0.015;
  static double searchSpacing(double height) => height * 0.02;
  static const double searchBorderRadius = 25.0;
  static const double searchBorderWidth = 2.0;
}