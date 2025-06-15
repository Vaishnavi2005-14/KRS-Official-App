import 'package:flutter/material.dart';
import 'package:krs_app/providers/attendance_provider.dart';
import 'package:krs_app/widgets/attendance_header.dart';
import 'package:krs_app/widgets/attendance_member_field.dart';

import 'package:krs_app/widgets/attendance_search_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AttendancePage extends StatefulWidget {
  final String title;
  final String date;

  const AttendancePage({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? authToken;
  final _searchController = TextEditingController();
  List _filteredMembers = [];
  List _allMembers = [];
  bool _isLoading = true;
  bool _hasTokenError = false;
  bool _hasSearched = false;

  final List<String> statuses = const ['Present', 'Absent', 'With Reason', 'Online'];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getToken();
    if (_isTokenValid()) {
      await _fetchMembers();
    } else {
      _handleTokenError();
    }
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString("token");
    });
  }

  bool _isTokenValid() => authToken != null && authToken!.isNotEmpty;

  void _handleTokenError() {
    setState(() {
      _isLoading = false;
      _hasTokenError = true;
    });
    _showTokenErrorSnackbar();
  }

  Future<void> _fetchMembers() async {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    await provider.fetchMembers(authToken!);
    _allMembers = provider.members;
    _filteredMembers = List.from(_allMembers);
    setState(() => _isLoading = false);
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        return member.name.toLowerCase().contains(query) || 
               member.roll.toLowerCase().contains(query);
      }).toList();
      _hasSearched = true;
    });
  }

  void _showTokenErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Authentication failed. Please login again.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      backgroundColor: const Color(0xFF040E1E),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Skeletonizer(
              enabled: _isLoading,
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_hasTokenError && !_isLoading) {
      return _buildErrorState();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AttendanceHeader(title: widget.title, date: widget.date),
        const SizedBox(height: 12),
        AttendanceSearchField(
          controller: _searchController,
          hasSearched: _hasSearched,
          onSearch: _onSearch,
          onClear: () {
            _searchController.clear();
            setState(() {
              _filteredMembers = List.from(_allMembers);
              _hasSearched = false;
            });
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Consumer<AttendanceProvider>(
            builder: (context, provider, _) {
              return AttendanceMemberList(
                filteredMembers: _filteredMembers,
                statuses: statuses,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Authentication Required',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _initializeData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
