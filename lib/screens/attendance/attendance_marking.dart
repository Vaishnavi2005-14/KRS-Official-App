import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/providers/attendance_provider.dart';
import 'package:krs_app/widgets/attendance/member_attendance_card.dart';
import 'package:krs_app/widgets/attendance/domain_filter_chips.dart';
import 'package:krs_app/widgets/attendance/attendance_search_bar.dart';
import 'package:krs_app/widgets/attendance/absence_reason_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:krs_app/models/member.dart';

class AttendanceMarkingPage extends StatefulWidget {
  const AttendanceMarkingPage({super.key});

  @override
  State<AttendanceMarkingPage> createState() => _AttendanceMarkingPageState();
}

class _AttendanceMarkingPageState extends State<AttendanceMarkingPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMembers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    try {
      final provider = Provider.of<AttendanceProvider>(context, listen: false);
      await provider.fetchMembersForAttendance();

      await Future.delayed(Duration(milliseconds: 500)); 

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading members: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'ATTENDANCE',
              style: TextStyle(
                color: Color(0xFFE5A122),
                fontSize: isTablet ? 28 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(isTablet ? 10 : 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
              ),
              child: Icon(
                Icons.list_alt,
                color: Colors.white,
                size: isTablet ? 28 : 24,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff040E1E),
        elevation: 0,
        toolbarHeight: isTablet ? 70 : 56,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: isTablet ? 28 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: screenWidth * 0.01,
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              bottom: screenWidth * 0.02,
            ),
            child: AttendanceSearchBar(
              controller: _searchController,
              onChanged: (value) {
                Provider.of<AttendanceProvider>(
                  context,
                  listen: false,
                ).updateSearchQuery(value);
              },
            ),
          ),

          Container(
            height: isTablet ? 80 : 60,
            child: Skeletonizer(
              enabled: _isLoading,
              child: DomainFilterChips(),
            ),
          ),

          Expanded(
            child: Skeletonizer(
              enabled: _isLoading,
              child:
                  _isLoading
                      ? _buildSkeletonList(screenWidth, screenHeight, isTablet)
                      : _buildMembersList(screenWidth, screenHeight, isTablet),
            ),
          ),

          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Consumer<AttendanceProvider>(
              builder: (context, provider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isSaving ? null : _handleSaveAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE5A122),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: isTablet ? 20 : 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 18 : 14),
                      ),
                    ),
                    child:
                        provider.isSaving
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: isTablet ? 24 : 20,
                                  width: isTablet ? 24 : 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Saving...',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: isTablet ? 22 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              'Save Attendance',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isTablet ? 22 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Color(0xff06132A),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: isTablet ? 60 : 50,
                    height: isTablet ? 60 : 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: isTablet ? 20 : 16,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: screenWidth * 0.5,
                          height: isTablet ? 16 : 12,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: isTablet ? 50 : 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: isTablet ? 50 : 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: isTablet ? 50 : 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: isTablet ? 50 : 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMembersList(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, child) {
        final filteredMembers = provider.filteredMembers;

        if (filteredMembers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: isTablet ? 120 : 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'No members found',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: isTablet ? 22 : 18,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          itemCount: filteredMembers.length,
          itemBuilder: (context, index) {
            final member = filteredMembers[index];
            return MemberAttendanceCard(
              member: member,
              onStatusChanged: (status) {
                if (status == 'Absent with reason') {
                  _showAbsenceReasonDialog(member);
                } else {
                  provider.updateMemberStatus(member.id, status);
                }
              },
            );
          },
        );
      },
    );
  }

  void _showAbsenceReasonDialog(Member member) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AbsenceReasonDialog(
            onSave: (reason) {
              Provider.of<AttendanceProvider>(
                context,
                listen: false,
              ).updateMemberStatusWithReason(
                member.id,
                'Absent with reason',
                reason,
              );
            },
            onCancel: () {
              Provider.of<AttendanceProvider>(
                context,
                listen: false,
              ).resetMemberStatus(member.id);
            },
          ),
    );
  }

  Future<void> _handleSaveAttendance() async {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);

    final unmarkedMembers = provider.getUnmarkedMembers();

    if (unmarkedMembers.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please mark attendance for all members'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Show',
            textColor: Colors.white,
            onPressed: () {
              provider.highlightUnmarkedMembers();
            },
          ),
        ),
      );
      return;
    }

    try {
      await provider.saveAttendance();
      _showSaveResultDialog(true);
    } catch (e) {
      _showSaveResultDialog(false, error: e.toString());
    }
  }

  void _showSaveResultDialog(bool success, {String? error}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Color(0xff06132A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
            ),
            child: Container(
              width: isTablet ? screenWidth * 0.5 : screenWidth * 0.8,
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color:
                          success
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      success ? Icons.check : Icons.error,
                      color: success ? Colors.green : Colors.red,
                      size: isTablet ? 60 : 48,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    success ? 'Attendance Saved!' : 'Save Failed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    success
                        ? 'Attendance has been successfully saved'
                        : error ?? 'Failed to save attendance',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 18 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (success) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE5A122),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 10 : 8,
                          ),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
