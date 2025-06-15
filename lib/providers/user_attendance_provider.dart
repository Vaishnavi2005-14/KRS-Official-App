import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserAttendanceProvider with ChangeNotifier {
  List<Map<String, dynamic>> _attendanceRecords = [];
  bool _isLoading = false;
  String? _error;
  String _userName = '';
  String _userDomain = '';

  List<Map<String, dynamic>> get attendanceRecords => _attendanceRecords;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get userName => _userName;
  String get userDomain => _userDomain;

  Future<void> fetchUserAttendance({
    required String token,
    required String userId,
    required String userName,
    required String userDomain,
  }) async {
    _isLoading = true;
    _error = null;
    _userName = userName;
    _userDomain = userDomain;
    notifyListeners();

    try {
      _attendanceRecords = await ApiService.getUserAttendanceById(
        token: token,
        userId: userId,
      );
      _isLoading = false;
      print('Fetched attendance records: $_attendanceRecords');
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Present Online':
        return Color(0xFFE5A122);
      case 'Absent':
      case 'Absent with reason':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
