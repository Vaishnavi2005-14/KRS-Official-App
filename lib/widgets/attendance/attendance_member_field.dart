import 'package:flutter/material.dart';
import 'attendance_member_card.dart';

class AttendanceMemberList extends StatelessWidget {
  final List filteredMembers;
  final List<String> statuses;

  const AttendanceMemberList({
    super.key,
    required this.filteredMembers,
    required this.statuses,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredMembers.isEmpty) {
      return const Center(
        child: Text(
          "No Record Available",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) {
        final member = filteredMembers[index];
        return AttendanceMemberCard(
          key: ValueKey(member.id),
          member: member,
          statuses: statuses,
        );
      },
    );
  }
}
