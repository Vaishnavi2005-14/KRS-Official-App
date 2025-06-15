import 'package:flutter/material.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xff040E1E)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_outlined,
              size: isTablet ? 120 : 80,
              color: Color(0xFFE5A122),
            ),
            SizedBox(height: screenHeight * 0.025),
            Text(
              'Notices',
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 32 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.012),
            Text(
              'Meow Meow...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: isTablet ? 20 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
