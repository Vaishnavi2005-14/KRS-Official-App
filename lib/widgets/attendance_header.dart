import 'package:flutter/material.dart';

class AttendanceHeader extends StatelessWidget {
  const AttendanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'ATTENDANCE',
        style: TextStyle(
          color: Colors.orange,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 30,
        ),
      ),
    );
  }
}