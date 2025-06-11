import 'package:flutter/material.dart';
import 'package:krs_app/providers/attendance_provider.dart';
import 'package:krs_app/widgets/attendance_header.dart';
import 'package:krs_app/widgets/attendance_member_field.dart'; // <-- Use the correct import
import 'package:krs_app/widgets/attendance_search_field.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String? authToken;

  final _searchController = TextEditingController();
  List _filteredMembers = [];
  List _allMembers = [];
  bool _isLoading = true;
  bool _hasSearched = false;
  bool _hasTokenError = false;

  final List<String> statuses = const ['Present', 'Absent', 'With Reason', 'Online'];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token != authToken) {
      setState(() {
        authToken = token;
      });
    }
  }

  Future<void> _initializeData() async {
    await getToken();
    if (_isTokenValid()) {
      await _fetchMembers();
    } else {
      setState(() {
        _isLoading = false;
        _hasTokenError = true;
      });
      _showTokenError();
    }
  }

  bool _isTokenValid() {
    return authToken != null && authToken!.isNotEmpty;
  }

  Future<bool> _ensureTokenIsAvailable() async {
    if (!_isTokenValid()) {
      await getToken();
    }
    return _isTokenValid();
  }

  Future<void> _fetchMembers() async {
    if (!await _ensureTokenIsAvailable()) {
      setState(() {
        _isLoading = false;
        _hasTokenError = true;
      });
      _showTokenError();
      return;
    }
    if (!mounted) return;
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    await provider.fetchMembers(authToken!);
    _allMembers = provider.members;
    _filteredMembers = List.from(_allMembers);
    setState(() {
      _isLoading = false;
      _hasTokenError = false;
    });
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        return member.name.toLowerCase().contains(query) ||
            member.rollNo.toLowerCase().contains(query);
      }).toList();
      _hasSearched = true;
    });
  }

  void _showTokenError() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication token not found. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitAttendance() async {
    if (!await _ensureTokenIsAvailable()) {
      _showTokenError();
      return;
    }
    if (!mounted) return;
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    await provider.submitAttendance(authToken!);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Attendance Submitted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: const Color(0xffE5A122)),
      backgroundColor: const Color(0xFF040E1E),
      body: SafeArea(
        child: GestureDetector(
          // Dismiss keyboard on tap outside input
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Skeletonizer(
              enabled: _isLoading,
              child: _hasTokenError && !_isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Authentication Error',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please login again to continue',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                                _hasTokenError = false;
                              });
                              await _initializeData();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AttendanceHeader(),
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
                              return RepaintBoundary(
                                child: AttendanceMemberList(
                                  filteredMembers: _filteredMembers,
                                  statuses: statuses,
                                ),
                              );
                            },
                          ),
                        ),
                        // Uncomment and use as needed:
                        // const SizedBox(height: 10),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Color(0xffE5A122),
                        //       foregroundColor: Colors.black,
                        //       padding: const EdgeInsets.symmetric(vertical: 16),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //     ),
                        //     onPressed: _submitAttendance,
                        //     child: const Text('Submit Attendance'),
                        //   ),
                        // ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
