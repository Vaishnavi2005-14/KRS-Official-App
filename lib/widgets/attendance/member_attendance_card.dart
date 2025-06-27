import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/models/member.dart';
import 'package:krs_app/providers/attendance_provider.dart';

class MemberAttendanceCard extends StatelessWidget {
  final Member member;
  final Function(String) onStatusChanged;

  const MemberAttendanceCard({
    super.key,
    required this.member,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Consumer<AttendanceProvider>(
      builder: (context, provider, child) {
        final selectedStatus = provider.selectedStatus[member.id] ?? '';
        final isHighlighted = provider.highlightedMembers.contains(member.id);

        return Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          decoration: BoxDecoration(
            color: Color(0xff06132A),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(
              color:
                  isHighlighted
                      ? Colors.red
                      : Color(0xFFE5A122).withAlpha(78),
              width: isHighlighted ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: isTablet ? 30 : 25,
                      backgroundColor: Color(0xFFE5A122),
                      backgroundImage:
                          member.image.isNotEmpty
                              ? NetworkImage(member.image)
                              : null,
                      child:
                          member.image.isEmpty
                              ? Text(
                                member.name.isNotEmpty
                                    ? member.name[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: isTablet ? 22 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : null,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            'Roll #${member.roll} • ${member.domain}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: isTablet ? 16 : 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatusButton(
                            context,
                            'Present',
                            Icons.check,
                            Colors.green,
                            selectedStatus == 'Present',
                            screenWidth,
                            isTablet,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildStatusButton(
                            context,
                            'Absent',
                            Icons.close,
                            Colors.red,
                            selectedStatus == 'Absent',
                            screenWidth,
                            isTablet,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatusButton(
                            context,
                            'With Reason',
                            Icons.edit_note,
                            Colors.orange,
                            selectedStatus == 'Absent with reason',
                            screenWidth,
                            isTablet,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildStatusButton(
                            context,
                            'Online',
                            Icons.language,
                            Colors.blue,
                            selectedStatus == 'Present Online',
                            screenWidth,
                            isTablet,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (selectedStatus == 'Absent with reason') ...[
                  SizedBox(height: screenHeight * 0.015),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: Color(0xff040E1E),
                      borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                      border: Border.all(color: Colors.orange.withAlpha(78)),
                    ),
                    child: Text(
                      provider.remarks[member.id]?.isNotEmpty == true
                          ? 'Reason: ${provider.remarks[member.id]}'
                          : 'Reason: Not specified',
                      style: TextStyle(
                        color: Colors.orange[300],
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    bool isSelected,
    double screenWidth,
    bool isTablet,
  ) {
    return InkWell(
      onTap: () {
        String status = '';
        switch (text) {
          case 'Present':
            status = 'Present';
            break;
          case 'Absent':
            status = 'Absent';
            break;
          case 'With Reason':
            status = 'Absent with reason';
            break;
          case 'Online':
            status = 'Present Online';
            break;
        }
        onStatusChanged(status);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 16 : 12,
          horizontal: screenWidth * 0.02,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withAlpha(38),
          borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
          border: Border.all(
            color: isSelected ? color : color.withAlpha(128),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: isTablet ? 20 : 16,
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontSize: isTablet ? 16 : 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
