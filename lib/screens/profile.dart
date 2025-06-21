import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  String? profileImage;
  String? domain;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      profileImage = prefs.getString('image');
      domain = prefs.getString("domain");
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF040E1E),
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: size.height * 0.15,
              right: 0,
              child: CustomPaint(
                size: Size(size.width, size.height * 0.6),
                painter: CurvedLinesPainter(),
              ),
            ),
            Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _buildProfileContent(size),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(color: Color(0xffE5A122), blurRadius: 80),
                ],
              ),
              child: SvgPicture.asset(
                height: h * 0.04,
                'assets/bell.svg',
                colorFilter: ColorFilter.mode(
                  Color(0xFFFFA000),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(color: Color(0xffE5A122), blurRadius: 80),
                ],
              ),
              child: Icon(Icons.settings_rounded, color: Color(0xffE5A122)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(Size size) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        Container(
          height: size.height * 0.15,
          width: size.height * 0.15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xffE5A122), Color(0xff194DA6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: size.height * 0.12,
              backgroundColor: Colors.black,
              child: ClipOval(
                child: Image(
                  image: NetworkImage(
                    (profileImage != null && profileImage!.isNotEmpty)
                        ? profileImage!
                        : 'https://krs.kiit.ac.in/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FKRS.31bc350a.png&w=384&q=75',
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          name ?? 'Name',
          style: GoogleFonts.inter(
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.bold,
            color: Color(0xffE5A122),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          "$domain Team",
          style: TextStyle(
            color: Color(0xffA4A4A4),
            fontSize: size.width * 0.04,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [Color(0xffE5A122), Color(0xff194DA6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: Icon(Icons.email_rounded, size: size.width * 0.05),
            ),
            SizedBox(width: size.width * 0.01),
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [Color(0xffE5A122), Color(0xff194DA6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: Text(
                email ?? 'krsmember@kiit.ac.in',
                style: GoogleFonts.inter(
                  fontSize: size.width * 0.04,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CurvedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFFFA000).withAlpha(78)
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
