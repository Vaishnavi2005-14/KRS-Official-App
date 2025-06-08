import 'package:flutter/material.dart';

class AttendanceHeader extends StatelessWidget {
  const AttendanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'ATTENDANCE',
        style: TextStyle(
          color: Color(0xffE5A122),
          fontWeight: FontWeight.w600,
          fontSize: 30,
        ),
      ),
    );
  }
}
