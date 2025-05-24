import 'package:flutter/material.dart';
import 'package:krs_app/home.dart';
import 'package:krs_app/screens/profile.dart';
import 'package:krs_app/screens/attendance_page.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final List<Widget> _screens = [
    const Home(),
    const AttendancePage(authToken: 'your_auth_token_here'),
    const ProfileScreen(),
  ];

  Widget get currentScreen => _screens[_selectedIndex];

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}