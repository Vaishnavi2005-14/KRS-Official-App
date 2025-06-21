import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krs_app/providers/loader.dart';
import 'package:krs_app/services/auth.dart';
import 'package:provider/provider.dart';
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
  String? designation;
  String? roll;
  String? year;
  String? branch;

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
      designation = prefs.getString("designation");
      roll = prefs.getString('rollNo');
      year = prefs.getString('year');
      branch = prefs.getString('branch');
    });
  }

  Future<void> _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final loaderProvider = Provider.of<LoaderProvider>(context, listen: false);

    loaderProvider.showLoader(context);

    await authService.logout();

    if (!mounted) return;
    loaderProvider.hideLoader();

    Navigator.pushReplacementNamed(context, '/login');

    Fluttertoast.showToast(
      msg: "You have been logged out successfully!",
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
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
                    child: ProfileContent(
                      name: name,
                      email: email,
                      profileImage: profileImage,
                      domain: domain,
                      designation: designation,
                      roll: roll,
                      year: year,
                      branch: branch,
                      onLogout: _logout,
                    ),
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
            onTap: _logout,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(color: Color(0xffE5A122), blurRadius: 80),
                ],
              ),
              child: Icon(Icons.logout, color: Color(0xffE5A122)),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final String? name;
  final String? email;
  final String? profileImage;
  final String? domain;
  final String? designation;
  final String? roll;
  final String? year;
  final String? branch;
  final VoidCallback onLogout;

  const ProfileContent({
    super.key,
    this.name,
    this.email,
    this.profileImage,
    this.domain,
    this.designation,
    this.roll,
    this.year,
    this.branch,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: size.height * 0.05),
        Container(
          height: size.height * 0.15,
          width: size.height * 0.15,
          decoration: const BoxDecoration(
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
                    profileImage ??
                        'https://krs.kiit.ac.in/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FKRS.31bc350a.png&w=384&q=75',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          name ?? 'Saswat Ranjan Behera',
          style: GoogleFonts.inter(
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.bold,
            color: const Color(0xffE5A122),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          "${domain ?? 'App Dev'} Team",
          style: TextStyle(
            color: const Color(0xffA4A4A4),
            fontSize: size.width * 0.04,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback:
                  (bounds) => const LinearGradient(
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
                  (bounds) => const LinearGradient(
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
        SizedBox(height: size.height * 0.04),

        Container(
          width: size.width * 0.9,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1F3D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Details',
                  style: GoogleFonts.inter(
                    color: const Color(0xffE5A122),
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.048,
                  ),
                ),
                const SizedBox(height: 16),
                if (roll != null) ...[
                  ProfileInfoRow(title: 'Roll No', value: roll!),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 16),
                if (designation != null) ...[
                  ProfileInfoRow(title: 'Designation', value: designation!),
                  const SizedBox(height: 12),
                ],
                if (year != null) ...[
                  ProfileInfoRow(title: 'Year', value: year!),
                  const SizedBox(height: 12),
                ],
                if (branch != null) ...[
                  ProfileInfoRow(title: 'Branch', value: branch!),
                  const SizedBox(height: 12),
                ],
                if (roll == null &&
                    designation == null &&
                    year == null &&
                    branch == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'No additional details available',
                      style: GoogleFonts.inter(
                        color: const Color(0xffA4A4A4),
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        SizedBox(height: size.height * 0.03),
      ],
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: const Color(0xffA4A4A4),
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
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
