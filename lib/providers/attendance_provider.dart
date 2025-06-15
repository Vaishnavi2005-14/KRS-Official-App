import 'package:flutter/widgets.dart';
import 'package:krs_app/models/attendance.dart';
import 'package:krs_app/models/attendance_record.dart';
import 'package:krs_app/models/member.dart';
import 'package:krs_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceProvider with ChangeNotifier {
  List<Member> _members = [];
  List<Member> _filteredMembers = [];
  Map<String, String> _selectedStatus = {};
  final Map<String, String> _remarks = {};
  final Map<String, bool> _isEditingRemarks = {};
  String? _expandedMemberId;

  // Meeting details state
  String? _meetingTopic;
  String? _meetingCategory;
  String? _meetingTeam;

  final Map<String, TextEditingController> _remarkControllers = {};

  List<Member> get members => _members;
  List<Member> get filteredMembers => _filteredMembers;
  Map<String, String> get selectedStatus => _selectedStatus;
  Map<String, String> get remarks => _remarks;
  Map<String, bool> get isEditingRemarks => _isEditingRemarks;
  String? get expandedMemberId => _expandedMemberId;
  String? get meetingTopic => _meetingTopic;
  String? get meetingCategory => _meetingCategory;
  String? get meetingTeam => _meetingTeam;

  /// Helper: Get token from SharedPreferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }
    return token;
  }

  /// Set meeting details (call before submitAttendance)
  void setMeetingDetails({String? topic, String? category, String? team}) {
    _meetingTopic = topic;
    _meetingCategory = category;
    _meetingTeam = team;
    notifyListeners();
  }

  void toggleExpanded(String memberId) {
    _expandedMemberId = (_expandedMemberId == memberId) ? null : memberId;
    notifyListeners();
  }

  /// Fetch all members from backend
  Future<void> fetchMembers(String s) async {
    try {
      final token = await _getToken();
      _members = await ApiService.fetchMembers(token);
      _filteredMembers = List.from(_members);
      _initializeMemberStates();
      notifyListeners();
    } catch (error) {
      print("Error fetching members: $error");
      rethrow;
    }
  }

  void _initializeMemberStates() {
    _selectedStatus = {for (var m in _members) m.id: 'Present'};
    _remarks.clear();
    _isEditingRemarks.clear();

    _remarkControllers.forEach((_, controller) => controller.dispose());
    _remarkControllers.clear();

    for (var m in _members) {
      _remarkControllers[m.id] = TextEditingController();
    }
  }

  /// Filter members by name or roll
  void filterMembers(String query) {
    final q = query.toLowerCase().trim();
    _filteredMembers = _members.where((member) {
      return member.name.toLowerCase().contains(q) ||
          member.roll.toLowerCase().contains(q);
    }).toList();
    notifyListeners();
  }

  /// Reset all filters
  void clearFilters() {
    _filteredMembers = List.from(_members);
    notifyListeners();
  }

  /// Update attendance status for a member
  void updateStatus(String memberId, String status) {
    _selectedStatus[memberId] = status;

    if (!['Absent', 'With Reason', 'Absent with reason'].contains(status)) {
      clearRemarkForMember(memberId);
    }
    notifyListeners();
  }

  /// Update remark for a member
  void updateRemark(String memberId, String remark) {
    _remarks[memberId] = remark;
    _remarkControllers[memberId]?.text = remark;
    notifyListeners();
  }

  /// Toggle editing state for remarks for a member
  void toggleEditingRemarks(String memberId) {
    _isEditingRemarks[memberId] = !(_isEditingRemarks[memberId] ?? false);
    notifyListeners();
  }

  /// Set editing state for remarks for a member
  void setEditingRemarks(String memberId, bool isEditing) {
    _isEditingRemarks[memberId] = isEditing;
    notifyListeners();
  }

  /// Clear remark for a member
  void clearRemarkForMember(String memberId) {
    _remarks.remove(memberId);
    _remarkControllers[memberId]?.text = '';
    _isEditingRemarks[memberId] = false;
    notifyListeners();
  }

  /// Get TextEditingController for a member's remark
  TextEditingController getRemarkController(String memberId) {
    if (!_remarkControllers.containsKey(memberId)) {
      _remarkControllers[memberId] =
          TextEditingController(text: _remarks[memberId] ?? '');
    }
    return _remarkControllers[memberId]!;
  }

  /// Submit attendance to backend
  Future<void> submitAttendance() async {
    try {
      final token = await _getToken();

      // Validate required fields
      if (_meetingTopic == null || _meetingTopic!.isEmpty) {
        throw Exception('Meeting topic is required');
      }
      if (_meetingCategory == null ||
          !['General', 'Domain'].contains(_meetingCategory)) {
        throw Exception('Invalid meeting category');
      }

      // Format date to dd/MM/yyyy
      final now = DateTime.now();
      final formattedDate =
          "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

      final attendance = Attendance(
        date: formattedDate,
        topic: _meetingTopic!,
        categoryType: _meetingCategory!,
        team: _meetingTeam ?? 'General',
        attendanceRecords: _members
            .map((m) => AttendanceRecord(
                  
                  status: _selectedStatus[m.id] ?? 'Present',
                  remarks: _remarks[m.id], name: '', domain: '', rollNo: '', userId: '',
                ))
            .toList(), id: '',
      );

      await ApiService.submitAttendance(token, attendance);

      // Clear form after successful submission
      _meetingTopic = null;
      _meetingCategory = null;
      _meetingTeam = null;
      _initializeMemberStates();
      notifyListeners();
    } catch (error) {
      print("Error submitting attendance: $error");
      rethrow;
    }
  }

  /// Dispose all remark controllers
  void disposeControllers() {
    for (var controller in _remarkControllers.values) {
      controller.dispose();
    }
    _remarkControllers.clear();
  }
}
