import 'package:flutter/material.dart';

class DateCard extends StatelessWidget {
  final String day;
  final String month;

  const DateCard({
    super.key,
    required this.day,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xffE5A122),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: const TextStyle(
              color: Color(0xff0f1419),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            month,
            style: const TextStyle(
              color: Color(0xff0f1419),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
