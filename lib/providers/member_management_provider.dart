import 'package:flutter/material.dart';
import '../services/member_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberManagementProvider with ChangeNotifier {
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _filteredMembers = [];
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  Set<String> _selectedMembers = {};
  Map<String, bool> _memberStatus = {};
  Map<String, String> _memberUpdates = {};

  // ... all your existing getters remain the same

  List<Map<String, dynamic>> get members => _members;
  List<Map<String, dynamic>> get filteredMembers => _filteredMembers;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  Set<String> get selectedMembers => _selectedMembers;
  Map<String, bool> get memberStatus => _memberStatus;
  Map<String, String> get memberUpdates => _memberUpdates;

  bool get hasChanges =>
      _selectedMembers.isNotEmpty || _memberUpdates.isNotEmpty;

  List<String> get availableDesignations => [
    'All',
    'Member',
    'ASCO',
    'Coordinator',
    'Lead',
    'Admin',
  ];

  List<String> get availableStatuses => ['All', 'active', 'inactive'];

  // ADD THIS NEW METHOD - This is the key fix!
  void clearState() {
    _members.clear();
    _filteredMembers.clear();
    _selectedMembers.clear();
    _memberStatus.clear();
    _memberUpdates.clear();
    _searchQuery = '';
    _selectedFilter = 'All';
    _isLoading = false;
    _isSaving = false;
    _error = null;
    notifyListeners();
  }

  // ... rest of your existing methods remain exactly the same

  Future<void> loadPendingMembers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      _members = await MemberApiService.getPendingMembers(token);
      _memberStatus.clear();
      _selectedMembers.clear();

      for (var member in _members) {
        _memberStatus[member['_id']] = true;
      }

      _updateFilteredMembers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllMembers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      _members = await MemberApiService.getAllMembers(token);
      _memberUpdates.clear();
      _updateFilteredMembers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ... all other existing methods remain the same
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _updateFilteredMembers();
    notifyListeners();
  }

  void updateFilter(String filter) {
    _selectedFilter = filter;
    _updateFilteredMembers();
    notifyListeners();
  }

  void toggleMemberSelection(String memberId) {
    if (_selectedMembers.contains(memberId)) {
      _selectedMembers.remove(memberId);
    } else {
      _selectedMembers.add(memberId);
    }
    notifyListeners();
  }

  void updateMemberApprovalStatus(String memberId, bool isActive) {
    _memberStatus[memberId] = isActive;
    if (!_selectedMembers.contains(memberId)) {
      _selectedMembers.add(memberId);
    }
    notifyListeners();
  }

  void updateMemberField(String memberId, String newValue) {
    _memberUpdates[memberId] = newValue;
    notifyListeners();
  }

  // ... rest of your methods remain the same

  Future<bool> deletePendingMember(String memberId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      await MemberApiService.deletePendingMember(token, memberId);

      _members.removeWhere((member) => member['_id'] == memberId);
      _selectedMembers.remove(memberId);
      _memberStatus.remove(memberId);
      _updateFilteredMembers();
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitApprovals() async {
    if (_selectedMembers.isEmpty) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      List<Map<String, String>> updates = _selectedMembers.map((memberId) {
        return {
          'user_id': memberId,
          'status': 'active',
        };
      }).toList();

      await MemberApiService.updateMemberStatus(token, updates);

      _members.removeWhere(
        (member) => _selectedMembers.contains(member['_id']),
      );
      _selectedMembers.clear();
      _updateFilteredMembers();

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitDesignationUpdates() async {
    if (_memberUpdates.isEmpty) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      List<Map<String, String>> updates = _memberUpdates.entries.map((entry) {
        return {'user_id': entry.key, 'designation': entry.value};
      }).toList();

      await MemberApiService.updateMemberDesignation(token, updates);

      for (var entry in _memberUpdates.entries) {
        final memberIndex = _members.indexWhere((m) => m['_id'] == entry.key);
        if (memberIndex != -1) {
          _members[memberIndex]['designation'] = entry.value;
        }
      }

      _memberUpdates.clear();
      _updateFilteredMembers();
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitStatusUpdates() async {
    if (_memberUpdates.isEmpty) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      List<Map<String, String>> updates = _memberUpdates.entries.map((entry) {
        return {'user_id': entry.key, 'status': entry.value};
      }).toList();

      await MemberApiService.updateMemberStatus(token, updates);

      for (var entry in _memberUpdates.entries) {
        final memberIndex = _members.indexWhere((m) => m['_id'] == entry.key);
        if (memberIndex != -1) {
          _members[memberIndex]['status'] = entry.value;
        }
      }

      _memberUpdates.clear();
      _updateFilteredMembers();
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  void _updateFilteredMembers() {
    _filteredMembers = _members.where((member) {
      bool matchesSearch = _searchQuery.isEmpty ||
          member['name'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
          member['email'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );

      bool matchesFilter = _selectedFilter == 'All' ||
          member['designation']?.toString() == _selectedFilter ||
          member['status']?.toString() == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void clearData() {
    _members.clear();
    _filteredMembers.clear();
    _selectedMembers.clear();
    _memberStatus.clear();
    _memberUpdates.clear();
    _searchQuery = '';
    _selectedFilter = 'All';
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    clearData();
    super.dispose();
  }
}