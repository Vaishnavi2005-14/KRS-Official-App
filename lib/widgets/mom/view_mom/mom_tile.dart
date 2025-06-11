import 'package:flutter/material.dart';

class MoMTile extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onTap;

  const MoMTile({
    super.key,
    required this.title,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.008),
        padding: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.04),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5A122)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: width * 0.045,
                color: const Color(0xFFE5A122),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.005),
            Text(
              date,
              style: TextStyle(
                color: Colors.white70,
                fontSize: width * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
