import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  String name = 'John Doe';
  String role = 'Operations';
  String profileImage =
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';
  String? domain;
  String? designation;
  String? roll;
  String? year;
  String? branch;
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
