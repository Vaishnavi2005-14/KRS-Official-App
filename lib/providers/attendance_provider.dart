import 'package:flutter/widgets.dart';
import 'package:krs_app/models/member.dart';
import 'package:krs_app/services/api_service.dart';

class AttendanceProvider with ChangeNotifier {
  List<Member> _members = [];
  Map<String, String> _selectedStatus = {};
  final Map<String, String> _remarks = {};
  final Map<String, bool> _isEditingRemarks = {};
  String? _expandedMemberId;

  final Map<String, TextEditingController> _remarkControllers = {};

  List<Member> get members => _members;
  Map<String, String> get selectedStatus => _selectedStatus;
  Map<String, String> get remarks => _remarks;
  Map<String, bool> get isEditingRemarks => _isEditingRemarks;
  String? get expandedMemberId => _expandedMemberId;

  void toggleExpanded(String memberId) {
    _expandedMemberId = (_expandedMemberId == memberId) ? null : memberId;
    notifyListeners();
  }

  Future<void> fetchMembers(String token) async {
    try {
      _members = await ApiService.fetchMembers(token);
      _selectedStatus = {for (var m in _members) m.id: 'Present'};
      _remarks.clear();
      _isEditingRemarks.clear();

      _remarkControllers.forEach((_, controller) => controller.dispose());
      _remarkControllers.clear();

      for (var m in _members) {
        _remarkControllers[m.id] = TextEditingController();
      }

      notifyListeners();
    } catch (error) {
      print("Error fetching members: $error");
    }
  }

  void updateStatus(String memberId, String status) {
    _selectedStatus[memberId] = status;

    if (!status.contains('Absent')) {
      clearRemarkForMember(memberId);
    }

    notifyListeners();
  }

  void updateRemark(String memberId, String remark) {
    _remarks[memberId] = remark;
    // Also update the controller text to keep in sync if needed
    _remarkControllers[memberId]?.text = remark;
    notifyListeners();
  }

  void toggleEditingRemarks(String memberId) {
    _isEditingRemarks[memberId] = !(_isEditingRemarks[memberId] ?? false);
    notifyListeners();
  }

  void setEditingRemarks(String memberId, bool isEditing) {
    _isEditingRemarks[memberId] = isEditing;
    notifyListeners();
  }

  void clearRemarkForMember(String memberId) {
    _remarks.remove(memberId);
    _remarkControllers[memberId]?.text = '';
    _isEditingRemarks[memberId] = false;
    notifyListeners();
  }

  TextEditingController getRemarkController(String memberId) {
    if (!_remarkControllers.containsKey(memberId)) {
      _remarkControllers[memberId] = TextEditingController(text: _remarks[memberId] ?? '');
    }
    return _remarkControllers[memberId]!;
  }

  Future<void> submitAttendance(String token) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final data = _selectedStatus.entries.map((e) => {
            '_id': e.key,
            'status': e.value,
            'remark': _remarks[e.key] ?? '',
            'date': today,
          }).toList();
      await ApiService.submitAttendance(token, data);
      print("Attendance submitted successfully");
    } catch (error) {
      print("Error submitting attendance: $error");
    }
  }

  void disposeControllers() {
    for (var controller in _remarkControllers.values) {
      controller.dispose();
    }
    _remarkControllers.clear();
  }
}
