import 'package:flutter/material.dart';
import 'package:krs_app/providers/attendance_provider.dart';
import 'package:krs_app/widgets/attendance_header.dart';
import 'package:krs_app/widgets/attendance_member_field.dart';
import 'package:krs_app/widgets/attendance_search_field.dart';

import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AttendancePage extends StatefulWidget {
  final String authToken;

  const AttendancePage({required this.authToken, super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _searchController = TextEditingController();
  List _filteredMembers = [];
  List _allMembers = [];
  bool _isLoading = true;
  bool _hasSearched = false;

  final List<String> statuses = ['Present', 'Absent', 'With Reason', 'Online'];

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    await provider.fetchMembers(widget.authToken);
    _allMembers = provider.members;
    _filteredMembers = List.from(_allMembers);
    setState(() {
      _isLoading = false;
    });
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredMembers =
          _allMembers.where((member) {
            return member.name.toLowerCase().contains(query) ||
                member.rollNo.toLowerCase().contains(query);
          }).toList();
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040E1E),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Skeletonizer(
            enabled: _isLoading,
            child: Consumer<AttendanceProvider>(
              builder: (context, provider, _) {
                return Column(
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
                      child: AttendanceMemberList(
                        filteredMembers: _filteredMembers,
                        statuses: statuses,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await provider.submitAttendance(widget.authToken);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Attendance Submitted'),
                              ),
                            );
                          }
                        },
                        child: const Text('Submit Attendance'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
