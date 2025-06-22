import 'package:flutter/material.dart';
import 'package:krs_app/screens/member_management/approve_pending_members.dart';
import 'package:krs_app/screens/member_management/change_member_role.dart';
import 'package:krs_app/screens/member_management/change_member_status.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/providers/member_management_provider.dart';

class MemberManagementHub extends StatelessWidget {
  const MemberManagementHub({super.key});

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
                  "Member Management",
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
                _buildMemberCard(
                  context,
                  title: "Approve Pending Users",
                  subtitle: "Review and approve new member requests",
                  icon: Icons.person_add,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isTablet: isTablet,
                  onTap: () {
                    _navigateToApprovePendingMembers(context);
                  },
                ),
                SizedBox(height: screenHeight * 0.025),
                _buildMemberCard(
                  context,
                  title: "Change Member Role",
                  subtitle: "Update member roles",
                  icon: Icons.badge,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isTablet: isTablet,
                  onTap: () {
                    _navigateToChangeMemberRole(context);
                  },
                ),
                SizedBox(height: screenHeight * 0.025),
                _buildMemberCard(
                  context,
                  title: "Change Member Status",
                  subtitle: "Activate or deactivate member accounts",
                  icon: Icons.toggle_on,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isTablet: isTablet,
                  onTap: () {
                    _navigateToChangeMemberStatus(context);
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

  void _navigateToApprovePendingMembers(BuildContext context) {
    Provider.of<MemberManagementProvider>(context, listen: false).clearState();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApprovePendingMembersPage()),
    );
  }

  void _navigateToChangeMemberRole(BuildContext context) {
    Provider.of<MemberManagementProvider>(context, listen: false).clearState();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeMemberRolePage()),
    );
  }

  void _navigateToChangeMemberStatus(BuildContext context) {
    // Clear provider state before navigation - THIS IS THE KEY FIX!
    Provider.of<MemberManagementProvider>(context, listen: false).clearState();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeMemberStatusPage()),
    );
  }

  Widget _buildMemberCard(
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
                          isTablet ? screenWidth * 0.06 : screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 16 : screenWidth * 0.038,
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
