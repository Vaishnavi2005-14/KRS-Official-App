import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  String name = 'Saswat Ranjan Behera';
  String role = 'App Dev';
  String profileImage =
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';
  bool isDarkMode = true;
  int currentIndex = 2;

  void updateCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}