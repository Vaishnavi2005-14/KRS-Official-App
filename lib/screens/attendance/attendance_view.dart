import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/attendance_record.dart';
import '../../providers/attendance_view_provider.dart';
import '../../services/api_service.dart';

class AttendanceViewPage extends StatefulWidget {
  final String title;
  final String date;

  const AttendanceViewPage({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  State<AttendanceViewPage> createState() => _AttendanceViewPageState();
}

class _AttendanceViewPageState extends State<AttendanceViewPage> {
  final List<String> domains = [
    "Advanced Embedded",
    "IoT",
    "Robotics",
    "App Development",
    "Machine Learning",
    "Web Development",
    "Operations",
    "Marketing",
    "Content",
    "Graphic Designing",
    "Video Editing",
    "Photography",
  ];

  final List<String> statuses = [
    'Present',
    'Absent',
    'Absent with reason',
    'Present Online',
  ];

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      final provider = Provider.of<AttendanceViewProvider>(
        context,
        listen: false,
      );
      await provider.fetchAttendance(token, widget.date, widget.title);
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
              'DETAILS',
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
                color: Colors.black.withAlpha(26),
                borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
              ),
              child: GestureDetector(
                onTap: _showDeleteDialog,
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: isTablet ? 28 : 24,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff040E1E),
        elevation: 0,
        toolbarHeight: isTablet ? 70 : 50,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: isTablet ? 28 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AttendanceViewProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE5A122),
                strokeWidth: 3,
              ),
            );
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: isTablet ? 120 : 80,
                    color: Colors.red,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Error: ${provider.error}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: isTablet ? 20 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final attendance = provider.attendance;
          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04,
                  top: screenWidth * 0.02,
                  bottom: screenWidth * 0.02,
                ),
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Color(0xff06132A),
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                  border: Border.all(
                    color: Color(0xFFE5A122).withAlpha(78),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.02),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Color(0xFFE5A122),
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.02),
                      child: Text(
                        widget.date,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff06132A),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          border: Border.all(
                            color: Color(0xFFE5A122),
                            width: 1.5,
                          ),
                        ),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: provider.selectedDomain,
                          hint: Text(
                            'All Domains',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 18 : 16,
                            ),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                          items:
                              domains
                                  .map(
                                    (d) => DropdownMenuItem(
                                      value: d,
                                      child: Text(
                                        d,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isTablet ? 18 : 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) => provider.selectedDomain = val,
                          dropdownColor: Color(0xff06132A),
                          iconEnabledColor: Color(0xFFE5A122),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff06132A),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          border: Border.all(
                            color: Color(0xFFE5A122),
                            width: 1.5,
                          ),
                        ),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: provider.selectedStatus,
                          hint: Text(
                            'All Status',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 18 : 16,
                            ),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                          items:
                              statuses
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(
                                        s,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isTablet ? 18 : 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) => provider.selectedStatus = val,
                          dropdownColor: Color(0xff06132A),
                          iconEnabledColor: Color(0xFFE5A122),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              Expanded(
                child:
                    attendance == null
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: isTablet ? 120 : 80,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                'No attendance data available',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: isTablet ? 20 : 16,
                                ),
                              ),
                            ],
                          ),
                        )
                        : provider.filteredRecords.isEmpty
                        ? Center(
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
                                'No records match your filters',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: isTablet ? 20 : 16,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          itemCount: provider.filteredRecords.length,
                          itemBuilder: (context, index) {
                            final record = provider.filteredRecords[index];
                            final isAbsentWithReason =
                                record.status == 'Absent with reason';
                            final hasRemarks =
                                record.remarks != null &&
                                record.remarks!.trim().isNotEmpty;

                            return Container(
                              margin: EdgeInsets.only(
                                bottom: screenHeight * 0.02,
                              ),
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: Color(0xff06132A),
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 16 : 12,
                                ),
                                border: Border.all(
                                  color: Colors.grey.withAlpha(78),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: isTablet ? 60 : 50,
                                        height: isTablet ? 60 : 50,
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xFFE5A122,
                                          ).withAlpha(51),
                                          shape: BoxShape.circle,
                                        ),
                                        child: CircleAvatar(
                                          radius: isTablet ? 30 : 25,
                                          backgroundColor: Color(0xFFE5A122),
                                          backgroundImage:
                                              (record.image != null &&
                                                      record.image!.isNotEmpty)
                                                  ? NetworkImage(record.image!)
                                                  : null,
                                          child:
                                              (record.image == null ||
                                                      record.image!.isEmpty)
                                                  ? Text(
                                                    record.name.isNotEmpty
                                                        ? record.name[0]
                                                            .toUpperCase()
                                                        : 'U',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          isTablet ? 22 : 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                  : null,
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.04),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              record.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isTablet ? 20 : 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              record.domain,
                                              style: TextStyle(
                                                color: Color(
                                                  0xFFE5A122,
                                                ).withAlpha(204),
                                                fontSize: isTablet ? 16 : 14,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              "Roll No: ${record.rollNo}",
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: isTablet ? 14 : 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap:
                                              isAbsentWithReason && hasRemarks
                                                  ? () => _showRemarksDialog(
                                                    record.remarks!,
                                                  )
                                                  : null,
                                          borderRadius: BorderRadius.circular(
                                            isTablet ? 10 : 8,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.04,
                                              vertical: isTablet ? 12 : 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                record.status,
                                              ).withAlpha(51),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    isTablet ? 10 : 8,
                                                  ),
                                              border: Border.all(
                                                color: _getStatusColor(
                                                  record.status,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  record.status,
                                                  style: TextStyle(
                                                    color: _getStatusColor(
                                                      record.status,
                                                    ),
                                                    fontSize:
                                                        isTablet ? 16 : 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                if (isAbsentWithReason &&
                                                    hasRemarks) ...[
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: _getStatusColor(
                                                      record.status,
                                                    ),
                                                    size: isTablet ? 18 : 16,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xFFE5A122,
                                          ).withAlpha(51),
                                          borderRadius: BorderRadius.circular(
                                            isTablet ? 10 : 8,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Color(0xFFE5A122),
                                            size: isTablet ? 24 : 20,
                                          ),
                                          onPressed:
                                              () => _showEditDialog(
                                                context,
                                                provider,
                                                record,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),

              if (provider.hasUnsavedChanges)
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          provider.isSaving
                              ? null
                              : () => _handleSaveAttendance(provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE5A122),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 18 : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
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
                                      fontSize: isTablet ? 20 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                              : Text(
                                'Save Attendance',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: isTablet ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Present Online':
        return Color(0xFFE5A122);
      case 'Absent':
      case 'Absent with reason':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showRemarksDialog(String remarks) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    showDialog(
      context: context,
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
                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFE5A122).withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Color(0xFFE5A122),
                      size: isTablet ? 48 : 36,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Absence Reason',
                    style: TextStyle(
                      color: Color(0xFFE5A122),
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Color(0xff040E1E),
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                      border: Border.all(
                        color: Colors.grey.withAlpha(78),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      remarks,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 18 : 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE5A122),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 8,
                          ),
                        ),
                      ),
                      child: Text(
                        'Close',
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

  void _showDeleteDialog() {
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
                      color: Colors.red.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: isTablet ? 60 : 48,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Delete Attendance Record?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : screenHeight * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Are you sure you want to delete this entire attendance record? This action cannot be undone.',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 18 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey, width: 1),
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 12 : 8,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleDeleteAttendance(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 12 : 8,
                              ),
                            ),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _handleDeleteAttendance() async {
    final provider = Provider.of<AttendanceViewProvider>(
      context,
      listen: false,
    );
    final attendance = provider.attendance;

    if (attendance == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      Navigator.pop(context);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Center(
              child: CircularProgressIndicator(color: Color(0xFFE5A122)),
            ),
      );

      await ApiService.deleteAttendanceRecord(
        token: token,
        attendanceId: attendance.id,
      );
      if (!mounted) return;
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      Fluttertoast.showToast(
        msg: "Attendance record deleted successfully",
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Error deleting record: ${e.toString()}',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _showEditDialog(
    BuildContext context,
    AttendanceViewProvider provider,
    AttendanceRecord record,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    String status = record.status;
    String remarks = record.remarks ?? '';
    final TextEditingController remarksController = TextEditingController(
      text: remarks,
    );

    bool showRemarksField = status == 'Absent with reason';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => Dialog(
                backgroundColor: Color(0xff06132A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                ),
                child: Container(
                  width: isTablet ? screenWidth * 0.6 : screenWidth * 0.9,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isTablet ? 16 : 12),
                          decoration: BoxDecoration(
                            color: Color(0xFFE5A122).withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Color(0xFFE5A122),
                            size: isTablet ? 48 : 36,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Text(
                          'Edit Attendance',
                          style: TextStyle(
                            color: Color(0xFFE5A122),
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Text(
                          record.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xff040E1E),
                            borderRadius: BorderRadius.circular(
                              isTablet ? 16 : 12,
                            ),
                            border: Border.all(
                              color: Color(0xFFE5A122),
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: status,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              labelStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: isTablet ? 16 : 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: isTablet ? 16 : 12,
                              ),
                            ),
                            items:
                                statuses
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(
                                          s,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isTablet ? 16 : 14,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              setState(() {
                                status = val!;
                                showRemarksField =
                                    status == 'Absent with reason';

                                if (!showRemarksField) {
                                  remarks = '';
                                  remarksController.clear();
                                }
                              });
                            },
                            dropdownColor: Color(0xff040E1E),
                            iconEnabledColor: Color(0xFFE5A122),
                          ),
                        ),

                        if (showRemarksField) ...[
                          SizedBox(height: screenWidth * 0.04),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xff040E1E),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 16 : 12,
                              ),
                              border: Border.all(
                                color: Color(0xFFE5A122),
                                width: 1.5,
                              ),
                            ),
                            child: TextField(
                              controller: remarksController,
                              onChanged: (val) => remarks = val,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 16 : 14,
                              ),
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Absence Reason *',
                                labelStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: isTablet ? 16 : 14,
                                ),
                                hintText:
                                    'Please provide reason for absence...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: isTablet ? 14 : 12,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(
                                  screenWidth * 0.04,
                                ),
                              ),
                            ),
                          ),
                        ],

                        SizedBox(height: screenWidth * 0.06),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 16 : 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 12 : 8,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (status == 'Absent with reason' &&
                                      remarks.trim().isEmpty) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "Please provide a reason for absence",
                                      backgroundColor: Colors.red,
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    return;
                                  }

                                  provider.updateRecordStatusAndReason(
                                    record.userId,
                                    status,
                                    status == 'Absent with reason'
                                        ? remarks
                                        : null,
                                  );
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE5A122),
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 16 : 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 12 : 8,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }

  Future<void> _handleSaveAttendance(AttendanceViewProvider provider) async {
    final attendance = provider.attendance;
    if (attendance == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      // print('Saving attendance for ${provider.changedRecords}...');
      provider.setSaving(true);
      for (final record in provider.changedRecords) {
        print('Record : ${record.status}, Remarks: ${record.remarks}');
        await ApiService.updateUserAttendance(
          token: token,
          attendanceId: attendance.id,
          userId: record.userId,
          status: record.status,
          remarks: record.remarks,
        );
      }
      provider.markSaved();
      _showSaveResultDialog(true);
    } catch (e) {
      _showSaveResultDialog(false, error: e.toString());
    } finally {
      provider.setSaving(false);
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
                              ? Colors.green.withAlpha(51)
                              : Colors.red.withAlpha(51),
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
                    success ? 'Attendance Updated!' : 'Update Failed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    success
                        ? 'Attendance has been successfully updated'
                        : error ?? 'Failed to update attendance',
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
                      onPressed: () => Navigator.pop(context),
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
