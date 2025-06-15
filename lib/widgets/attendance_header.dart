import 'package:flutter/material.dart';

class AttendanceHeader extends StatelessWidget {
  final String title;
  final String date;

  const AttendanceHeader({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'ATTENDANCE',
          style: TextStyle(
            color: Color(0xffE5A122),
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
