// attendance_view_provider.dart
import 'package:flutter/material.dart';
import 'package:krs_app/models/attendance_record.dart';
import '../models/attendance.dart';
import '../services/api_service.dart';

class AttendanceViewProvider with ChangeNotifier {
  Attendance? _attendance;
  bool _isLoading = false;
  String? _error;
  String? _selectedDomain;
  String? _selectedStatus;
  bool _hasUnsavedChanges = false;
  final Set<String> _changedUserIds = {};

  Attendance? get attendance => _attendance;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedDomain => _selectedDomain;
  String? get selectedStatus => _selectedStatus;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  set selectedDomain(String? value) {
    _selectedDomain = value;
    notifyListeners();
  }

  set selectedStatus(String? value) {
    _selectedStatus = value;
    notifyListeners();
  }

  Future<void> fetchAttendance(String token, String date, String topic) async {
    _isLoading = true;
    _error = null;
    _selectedDomain = null;
    _selectedStatus = null;
    _hasUnsavedChanges = false;
    notifyListeners();
    
    try {
      final allAttendances = await ApiService.fetchAllAttendance(token);
      try {
        _attendance = allAttendances.firstWhere(
          (a) => a.date == date && a.topic == topic,
        );
      } catch (e) {
        _attendance = null;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  List<AttendanceRecord> get filteredRecords {
    if (_attendance == null) return [];
    return _attendance!.attendanceRecords.where((record) {
      final domainMatch = _selectedDomain == null || record.domain == _selectedDomain;
      final statusMatch = _selectedStatus == null || record.status == _selectedStatus;
      return domainMatch && statusMatch;
    }).toList();
  }

  void updateRecordStatusAndReason(String userId, String newStatus, String newReason) {
    if (_attendance == null) return;
    final idx = _attendance!.attendanceRecords.indexWhere((r) => r.userId == userId);
    if (idx != -1) {
      _attendance!.attendanceRecords[idx] = _attendance!.attendanceRecords[idx].copyWith(
        status: newStatus,
        remarks: newReason,
      );
      _changedUserIds.add(userId);
      _hasUnsavedChanges = true;
      notifyListeners();
    }
  }

  List<AttendanceRecord> get changedRecords {
    if (_attendance == null) return [];
    return _attendance!.attendanceRecords
        .where((r) => _changedUserIds.contains(r.userId))
        .toList();
  }

  void markSaved() {
    _changedUserIds.clear();
    _hasUnsavedChanges = false;
    notifyListeners();
  }
}
