import 'package:flutter/material.dart';
import 'package:krs_app/models/member.dart';
import 'package:krs_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AttendanceStatus {
  present('Present'),
  absent('Absent'),
  absentWithReason('Absent with reason'),
  presentOnline('Present Online');

  const AttendanceStatus(this.value);
  final String value;
}

class AttendanceProvider with ChangeNotifier {
  List<Member> _members = [];
  Map<String, String> _selectedStatus = {};
  final Map<String, String> _remarks = {};
  final Map<String, bool> _isEditingRemarks = {};
  String? _expandedMemberId;
  final Map<String, TextEditingController> _remarkControllers = {};

  String _topic = '';
  DateTime _selectedDate = DateTime.now();
  String _categoryType = 'General';
  String _team = 'General';

  List<String> _availableDomains = [];
  String _selectedDomain = 'All Teams';
  String _searchQuery = '';
  List<Member> _filteredMembers = [];

  bool _isLoading = false;
  bool _isSaving = false;
  Set<String> _highlightedMembers = {};

  List<Member> get members => _members;
  Map<String, String> get selectedStatus => _selectedStatus;
  Map<String, String> get remarks => _remarks;
  Map<String, bool> get isEditingRemarks => _isEditingRemarks;
  String? get expandedMemberId => _expandedMemberId;

  String get topic => _topic;
  DateTime get selectedDate => _selectedDate;
  String get categoryType => _categoryType;
  String get team => _team;

  List<String> get availableDomains => _availableDomains;
  String get selectedDomain => _selectedDomain;
  String get searchQuery => _searchQuery;
  List<Member> get filteredMembers => _filteredMembers;

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  Set<String> get highlightedMembers => _highlightedMembers;

  void setAttendanceSession({
    required String topic,
    required DateTime date,
    required String categoryType,
    required String team,
  }) {
    _topic = topic;
    _selectedDate = date;
    _categoryType = categoryType;
    _team = team;
  }

  Future<void> fetchMembersForAttendance() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception('No authentication token found');
      }

      _members = await ApiService.fetchMembers(token, _team);

      if (_categoryType == 'Domain' && _team != 'General') {
        _members = _members.where((member) => member.domain == _team).toList();
      }

      _selectedStatus = {for (var m in _members) m.id: ''};
      _remarks.clear();
      _isEditingRemarks.clear();
      _highlightedMembers.clear();

      _remarkControllers.forEach((_, controller) => controller.dispose());
      _remarkControllers.clear();

      for (var m in _members) {
        _remarkControllers[m.id] = TextEditingController();
      }

      _availableDomains = ['All Teams'];
      _availableDomains.addAll(
        _members.map((m) => m.domain).toSet().toList()..sort(),
      );

      _updateFilteredMembers();

      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _updateFilteredMembers();
    notifyListeners();
  }

  void updateSelectedDomain(String domain) {
    _selectedDomain = domain;
    _updateFilteredMembers();
    notifyListeners();
  }

  void _updateFilteredMembers() {
    _filteredMembers =
        _members.where((member) {
          bool matchesDomain =
              _selectedDomain == 'All Teams' ||
              member.domain == _selectedDomain;

          bool matchesSearch =
              _searchQuery.isEmpty ||
              member.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              member.roll.toLowerCase().contains(_searchQuery.toLowerCase());

          return matchesDomain && matchesSearch;
        }).toList();
  }

  void updateMemberStatus(String memberId, String status) {
    _selectedStatus[memberId] = status;
    _highlightedMembers.remove(memberId);

    if (status != 'Absent with reason') {
      clearRemarkForMember(memberId);
    }

    notifyListeners();
  }

  void updateMemberStatusWithReason(
    String memberId,
    String status,
    String reason,
  ) {
    _selectedStatus[memberId] = status;
    _remarks[memberId] = reason;
    _remarkControllers[memberId]?.text = reason;
    _highlightedMembers.remove(memberId);
    notifyListeners();
  }

  void resetMemberStatus(String memberId) {
    _selectedStatus[memberId] = '';
    clearRemarkForMember(memberId);
    notifyListeners();
  }

  List<Member> getUnmarkedMembers() {
    return _members.where((member) {
      final status = _selectedStatus[member.id];
      return status == null || status.isEmpty;
    }).toList();
  }

  void highlightUnmarkedMembers() {
    _highlightedMembers.clear();
    _highlightedMembers.addAll(getUnmarkedMembers().map((member) => member.id));
    notifyListeners();
  }

  Future<void> saveAttendance() async {
    try {
      _isSaving = true;
      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final attendanceData = {
        'date': _selectedDate.toIso8601String(),
        'topic': _topic,
        'categoryType': _categoryType,
        'team': _team,
        'attendanceRecords':
            _selectedStatus.entries.map((entry) {
              return {
                'user': entry.key,
                'status': entry.value,
                'remarks': _remarks[entry.key] ?? '',
              };
            }).toList(),
      };
      print("Saving attendance data: $attendanceData");
      await ApiService.submitAttendanceSession(token, attendanceData);

      _isSaving = false;
      notifyListeners();
    } catch (error) {
      _isSaving = false;
      notifyListeners();
      throw error;
    }
  }

  void toggleExpanded(String memberId) {
    _expandedMemberId = (_expandedMemberId == memberId) ? null : memberId;
    notifyListeners();
  }

  Future<void> fetchMembers(String token) async {
    try {
      _members = await ApiService.fetchMembers(token, _team);
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
      _remarkControllers[memberId] = TextEditingController(
        text: _remarks[memberId] ?? '',
      );
    }
    return _remarkControllers[memberId]!;
  }

  // Future<void> submitAttendance(String token) async {
  //   try {
  //     final today = DateTime.now().toIso8601String().split('T')[0];
  //     final data =
  //         _selectedStatus.entries
  //             .map(
  //               (e) => {
  //                 '_id': e.key,
  //                 'status': e.value,
  //                 'remark': _remarks[e.key] ?? '',
  //                 'date': today,
  //               },
  //             )
  //             .toList();
  //     print("Submitting attendance data: $data");
  //     await ApiService.submitAttendance(token, data);
  //     print("Attendance submitted successfully");
  //   } catch (error) {
  //     print("Error submitting attendance: $error");
  //   }
  // }

  void disposeControllers() {
    for (var controller in _remarkControllers.values) {
      controller.dispose();
    }
    _remarkControllers.clear();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
