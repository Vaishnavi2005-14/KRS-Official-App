import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/member.dart';

class UserSelectionProvider with ChangeNotifier {
  List<Member> _allMembers = [];
  List<Member> _filteredMembers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Member> get allMembers => _allMembers;
  List<Member> get filteredMembers => _filteredMembers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> fetchMembers(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allMembers = await ApiService.fetchMembersForSelection(token, 'General');
      _filteredMembers = _allMembers;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filteredMembers =
        _allMembers.where((member) {
          final name = member.name.toLowerCase();
          final domain = member.domain.toLowerCase();
          final roll = member.roll.toLowerCase();
          final searchLower = query.toLowerCase();

          return name.contains(searchLower) ||
              domain.contains(searchLower) ||
              roll.contains(searchLower);
        }).toList();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredMembers = _allMembers;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

}
