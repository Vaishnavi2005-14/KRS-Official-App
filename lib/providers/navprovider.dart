import 'package:flutter/material.dart';
import 'package:krs_app/screens/dashboard.dart';
import 'package:krs_app/screens/notice/notices.dart';
import 'package:krs_app/screens/profile.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final List<Widget> _screens = [
    DashboardScreen(),
    NoticeBoardPage(),
    ProfileScreen()
  ];

  Widget get currentScreen => _screens[_selectedIndex];

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void resetToHome() {
    _selectedIndex = 0;
    notifyListeners();
  }
}