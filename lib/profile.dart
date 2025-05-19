import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileModel extends ChangeNotifier {
  String name = 'Saswat Ranjan Behera';
  String role = 'App Dev';
  String profileImage =
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';
  bool isDarkMode = true;
  int currentIndex = 2;

  void updateCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Consumer<ProfileModel>(
      builder: (context, profileData, _) {
        return Scaffold(
          body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(color: Color(0xFF040E1E)),
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.15,
                  right: 0,
                  child: _buildCurvedLines(screenWidth, screenHeight),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      _buildTopBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: _buildProfileContent(
                            context,
                            profileData,
                            screenWidth,
                            screenHeight,
                          ),
                        ),
                      ),
                      _buildBottomNavBar(profileData),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.mail, color: Color(0xFFFFA000), size: 28),
              const SizedBox(width: 8),
              Text(
                'Inbox',
                style: GoogleFonts.inter(
                  color: const Color(0xFFFFA000),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Icon(Icons.settings, color: Color(0xFFFFA000), size: 28),
        ],
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    ProfileModel profileData,
    double width,
    double height,
  ) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.05),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFA000).withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: width * 0.15,
              backgroundImage: NetworkImage(profileData.profileImage),
            ),
          ),
          SizedBox(height: height * 0.03),
          Text(
            profileData.name,
            style: GoogleFonts.inter(
              fontSize: width * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            profileData.role,
            style: GoogleFonts.inter(
              fontSize: width * 0.04,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: height * 0.04),
          _buildStatsSection(width),
          SizedBox(height: height * 0.04),
          _buildActionButtons(width),
          SizedBox(height: height * 0.1),
        ],
      ),
    );
  }

  Widget _buildStatsSection(double width) {
    return Container(
      width: width * 0.9,
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('158', 'Projects'),
          _verticalDivider(),
          _buildStatItem('2.4k', 'Followers'),
          _verticalDivider(),
          _buildStatItem('532', 'Following'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.3));
  }

  Widget _buildActionButtons(double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        children: [
          Expanded(child: _buildButton('Edit Profile', Icons.edit)),
          const SizedBox(width: 10),
          Expanded(child: _buildButton('Share', Icons.share)),
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData icon) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A2435),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: const Color(0xFFFFA000).withOpacity(0.5)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFFFA000), size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurvedLines(double width, double height) {
    return CustomPaint(
      size: Size(width, height * 0.6),
      painter: CurvedLinesPainter(),
    );
  }

  Widget _buildBottomNavBar(ProfileModel profileData) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF040E1E),
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 0, profileData),
          _buildNavItem(Icons.apps, 1, profileData),
          _buildNavItem(Icons.person, 2, profileData),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, ProfileModel profileData) {
    final isSelected = profileData.currentIndex == index;

    return GestureDetector(
      onTap: () => profileData.updateCurrentIndex(index),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFA000) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFFFFA000),
          size: 28,
        ),
      ),
    );
  }
}

class CurvedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFFFA000).withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    for (int i = 0; i < 5; i++) {
      final path = Path();
      final startY = size.height * 0.05 + (i * size.height * 0.05);
      path.moveTo(0, startY);
      path.quadraticBezierTo(
        size.width * 0.5,
        startY + size.height * 0.15,
        size.width,
        startY + size.height * 0.03,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
