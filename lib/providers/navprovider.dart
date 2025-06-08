import 'package:flutter/material.dart';
import 'package:krs_app/home.dart';
import 'package:krs_app/screens/attendance_home.dart';
import 'package:krs_app/screens/profile.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final List<Widget> _screens = [
    const Home(),
    const AttendanceHome(),
    const ProfileScreen(),
  ];

  Widget get currentScreen => _screens[_selectedIndex];

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
