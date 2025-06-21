import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/attendance.dart';

class AttendanceGatewayProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  DateTime? _fromDate;
  DateTime? _toDate;

  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  void setFromDate(DateTime? date) {
    _fromDate = date;
    notifyListeners();
  }

  void setToDate(DateTime? date) {
    _toDate = date;
    notifyListeners();
  }

  bool get canProceed => _fromDate != null && _toDate != null;

  void clearDates() {
    _fromDate = null;
    _toDate = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<List<Attendance>> fetchAttendanceByRange(String token) async {
    if (!canProceed) {
      throw Exception('Please select both from and to dates');
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fromDateStr = '${_fromDate!.day.toString().padLeft(2, '0')}/${_fromDate!.month.toString().padLeft(2, '0')}/${_fromDate!.year}';
      final toDateStr = '${_toDate!.day.toString().padLeft(2, '0')}/${_toDate!.month.toString().padLeft(2, '0')}/${_toDate!.year}';
      
      final result = await ApiService.fetchAttendanceByDateRange(
        token: token,
        from: fromDateStr,
        to: toDateStr,
      );
      
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

}