import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/screens/attendance/filtered_attendance_record.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/attendance_gateway_provider.dart';
import 'attendance_record.dart';
import 'user_selection.dart';

class AttendanceGatewayPage extends StatefulWidget {
  const AttendanceGatewayPage({super.key});

  @override
  State<AttendanceGatewayPage> createState() => _AttendanceGatewayPageState();
}

class _AttendanceGatewayPageState extends State<AttendanceGatewayPage> {
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
              'OPTIONS',
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
              child: Icon(
                Icons.dashboard,
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
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: ElevatedButton(
                      onPressed: () => _showDateRangeDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff06132A),
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          side: BorderSide(
                            color: Color(0xFFE5A122).withAlpha(78),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(isTablet ? 12 : 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5A122).withAlpha(51),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 10 : 8,
                              ),
                            ),
                            child: Icon(
                              Icons.date_range,
                              color: Color(0xFFE5A122),
                              size: isTablet ? 28 : 24,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'View & Edit Attendance Between',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 22 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  'Select date range to view & edit attendance records',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFE5A122),
                            size: isTablet ? 20 : 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSelectionPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff06132A),
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          side: BorderSide(
                            color: Color(0xFFE5A122).withAlpha(78),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(isTablet ? 12 : 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5A122).withAlpha(51),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 10 : 8,
                              ),
                            ),
                            child: Icon(
                              Icons.person_search,
                              color: Color(0xFFE5A122),
                              size: isTablet ? 28 : 24,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Individual Attendance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 22 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  'View attendance details for a specific person',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFE5A122),
                            size: isTablet ? 20 : 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceRecordsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff06132A),
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          side: BorderSide(
                            color: Color(0xFFE5A122).withAlpha(78),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(isTablet ? 12 : 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5A122).withAlpha(51),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 10 : 8,
                              ),
                            ),
                            child: Icon(
                              Icons.list_alt,
                              color: Color(0xFFE5A122),
                              size: isTablet ? 30 : 24,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Show All Attendance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 22 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  'View and edit all attendance records and sessions',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFE5A122),
                            size: isTablet ? 20 : 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangeDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => ChangeNotifierProvider(
            create: (_) => AttendanceGatewayProvider(),
            child: Consumer<AttendanceGatewayProvider>(
              builder:
                  (context, provider, _) => Dialog(
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
                                Icons.date_range,
                                color: Color(0xFFE5A122),
                                size: isTablet ? 48 : 36,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'Select Date Range',
                              style: TextStyle(
                                color: Color(0xFFE5A122),
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Choose the period for attendance records',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isTablet ? 16 : 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight * 0.03),

                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xff040E1E),
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 16 : 12,
                                ),
                                border: Border.all(
                                  color: Color(0xFFE5A122),
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFFE5A122),
                                  size: isTablet ? 24 : 20,
                                ),
                                title: Text(
                                  provider.fromDate == null
                                      ? 'Select From Date'
                                      : '${provider.fromDate!.day.toString().padLeft(2, '0')}/${provider.fromDate!.month.toString().padLeft(2, '0')}/${provider.fromDate!.year}',
                                  style: TextStyle(
                                    color:
                                        provider.fromDate == null
                                            ? Colors.white70
                                            : Colors.white,
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                                ),
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        provider.fromDate ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary: Color(0xFFE5A122),
                                            surface: Color(0xff06132A),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (date != null) {
                                    provider.setFromDate(date);
                                  }
                                },
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xff040E1E),
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 16 : 12,
                                ),
                                border: Border.all(
                                  color: Color(0xFFE5A122),
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFFE5A122),
                                  size: isTablet ? 24 : 20,
                                ),
                                title: Text(
                                  provider.toDate == null
                                      ? 'Select To Date'
                                      : '${provider.toDate!.day.toString().padLeft(2, '0')}/${provider.toDate!.month.toString().padLeft(2, '0')}/${provider.toDate!.year}',
                                  style: TextStyle(
                                    color:
                                        provider.toDate == null
                                            ? Colors.white70
                                            : Colors.white,
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                                ),
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        provider.toDate ?? DateTime.now(),
                                    firstDate:
                                        provider.fromDate ?? DateTime(2020),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary: Color(0xFFE5A122),
                                            surface: Color(0xff06132A),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (date != null) {
                                    provider.setToDate(date);
                                  }
                                },
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.04),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      provider.clearDates();
                                      Navigator.pop(context);
                                    },
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
                                    onPressed:
                                        provider.canProceed &&
                                                !provider.isLoading
                                            ? () => _handleDateRangeSelection(
                                              provider,
                                            )
                                            : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE5A122),
                                      padding: EdgeInsets.symmetric(
                                        vertical: isTablet ? 16 : 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          isTablet ? 12 : 8,
                                        ),
                                        side: BorderSide(
                                          color: Color(0xFFE5A122),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child:
                                        provider.isLoading
                                            ? SizedBox(
                                              height: isTablet ? 20 : 16,
                                              width: isTablet ? 20 : 16,
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : Text(
                                              'View Records',
                                              style: TextStyle(
                                                color: Colors.white70,
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
            ),
          ),
    );
  }

  Future<void> _handleDateRangeSelection(
    AttendanceGatewayProvider provider,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final attendanceRecords = await provider.fetchAttendanceByRange(token);
      if (!mounted) return;
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => FilteredAttendanceRecordsPage(
                attendanceRecords: attendanceRecords,
                fromDate: provider.fromDate!,
                toDate: provider.toDate!,
              ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
