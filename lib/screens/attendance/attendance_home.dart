import 'package:flutter/material.dart';
import 'package:krs_app/screens/attendance/attendance_gateway.dart';
import 'package:krs_app/widgets/attendance/attendance_setup_dialog.dart';

class AttendanceHomePage extends StatelessWidget {
  const AttendanceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Attendance Management",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 32 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.012),
                Text(
                  "Choose an option to continue",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: isTablet ? 18 : 16,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildAttendanceCard(
                  context,
                  title: "Mark New Attendance",
                  subtitle: "Create and mark attendance for today",
                  icon: Icons.add_circle_outline,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isTablet: isTablet,
                  onTap: () {
                    _showAttendanceSetupDialog(context);
                  },
                ),
                SizedBox(height: screenHeight * 0.025),
                _buildAttendanceCard(
                  context,
                  title: "View Attendance",
                  subtitle: "Access attendance records and analytics",
                  icon: Icons.analytics_outlined,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isTablet: isTablet,
                  onTap: () {
                    _navigateToAttendanceGateway(context);
                  },
                ),

                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAttendanceSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AttendanceSetupDialog(),
    );
  }

  void _navigateToAttendanceGateway(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AttendanceGatewayPage()),
    );
  }

  Widget _buildAttendanceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          color: Color(0xff06132A),
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          border: Border.all(
            color: Color(0xFFE5A122).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: Color(0xFFE5A122).withOpacity(0.2),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
              ),
              child: Icon(
                icon,
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
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          isTablet ? screenWidth * 0.06 : screenWidth * 0.048,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 16 : screenWidth * 0.04,
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
    );
  }
}