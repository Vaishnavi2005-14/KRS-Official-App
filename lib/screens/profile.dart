import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krs_app/providers/admin_nav_provider.dart';
import 'package:krs_app/providers/loader.dart';
import 'package:krs_app/providers/navprovider.dart';
import 'package:krs_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  String? name;
  String? email;
  String? profileImage;
  String? domain;
  String? designation;
  String? roll;
  String? year;
  String? branch;
  String? phone;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _bounceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    loadData();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _bounceController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void logout() async {
    final shouldLogout = await _showLogoutConfirmation();
    if (!shouldLogout) return;

    final AuthService authService = AuthService();
    Provider.of<LoaderProvider>(context, listen: false).showLoader(context);

    await authService.logout();
    if (!mounted) return;
    Provider.of<LoaderProvider>(context, listen: false).hideLoader();

    Provider.of<NavigationProvider>(context, listen: false).resetToHome();
    Provider.of<AdminNavigationProvider>(context, listen: false).resetToHome();

    Navigator.pushReplacementNamed(context, '/login');

    Fluttertoast.showToast(
      msg: "You have been logged out successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color(0xff194DA6),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<bool> _showLogoutConfirmation() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => Dialog(
                backgroundColor: Color(0xff06132A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Color(0xFFE5A122), width: 1.5),
                ),
                elevation: 12,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff06132A), Color(0xff1A233A)],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(38),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withAlpha(51),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: Colors.orange,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Confirm Logout',
                        style: GoogleFonts.poppins(
                          color: Color(0xFFE5A122),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xff1A233A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.withAlpha(77),
                          ),
                        ),
                        child: Text(
                          'Are you sure you want to logout? You will need to sign in again to access your account.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[600]!),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                'Logout',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ) ??
        false;
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
      phone = prefs.getString('phone');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xff06132A), toolbarHeight: 0),
      backgroundColor: const Color(0xff06132A),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff06132A)],
              stops: [0.0],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: size.height * 0.15,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: CustomPaint(
                    size: Size(size.width, size.height * 0.6),
                    painter: CurvedLinesPainter(),
                  ),
                ),
              ),
              Column(
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildTopBar(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: ProfileContent(
                            name: name,
                            email: email,
                            profileImage: profileImage,
                            domain: domain,
                            designation: designation,
                            roll: roll,
                            year: year,
                            branch: branch,
                            phone: phone,
                            onLogout: logout,
                            bounceAnimation: _bounceAnimation,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final double h = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE5A122).withAlpha(77)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE5A122).withAlpha(25),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFE5A122).withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person, color: Color(0xFFE5A122), size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.poppins(
                      color: Color(0xFFE5A122),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Manage your account',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: logout,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withAlpha(77)),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ],
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
  final String? phone;
  final String? status;
  final VoidCallback onLogout;
  final Animation<double> bounceAnimation;

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
    this.phone,
    this.status,
    required this.onLogout,
    required this.bounceAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Column(
      children: [
        SizedBox(height: size.height * 0.03),

        ScaleTransition(
          scale: bounceAnimation,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xffE5A122), Color(0xff194DA6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffE5A122).withAlpha(77),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Container(
              height: size.height * 0.15,
              width: size.height * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff06132A),
                border: Border.all(color: Color(0xff1A233A), width: 3),
              ),
              child: ClipOval(
                child: Image.network(
                  (profileImage?.isNotEmpty ?? false)
                      ? profileImage!
                      : 'https://krs.kiit.ac.in/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FKRS.31bc350a.png&w=384&q=75',
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE5A122).withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: size.height * 0.06,
                          color: Color(0xFFE5A122),
                        ),
                      ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: size.height * 0.025),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xff06132A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFE5A122).withAlpha(77)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE5A122).withAlpha(25),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [Color(0xffE5A122), Color(0xff194DA6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                child: Text(
                  name ?? 'Name',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 28 : size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE5A122).withAlpha(51),
                      Color(0xff194DA6).withAlpha(51),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFE5A122).withAlpha(77)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group, color: Color(0xFFE5A122), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "${domain?.isNotEmpty ?? false ? domain! : 'Domain'} Team",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: isTablet ? 16 : size.width * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xff1A233A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE5A122).withAlpha(51)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE5A122).withAlpha(51),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.email_rounded,
                        color: Color(0xFFE5A122),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email?.isNotEmpty ?? false
                                ? email!
                                : 'krsmember@kiit.ac.in',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 16 : size.width * 0.035,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: size.height * 0.03),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xff06132A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFE5A122).withAlpha(77)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE5A122).withAlpha(25),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE5A122).withAlpha(25),
                      Color(0xff194DA6).withAlpha(25),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFE5A122).withAlpha(51),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Color(0xFFE5A122),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Additional Details',
                      style: GoogleFonts.poppins(
                        color: Color(0xffE5A122),
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 20 : size.width * 0.048,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: _buildDetailsContent(isTablet, size),
              ),
            ],
          ),
        ),

        SizedBox(height: size.height * 0.03),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Colors.red.withAlpha(77),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: size.height * 0.05),
      ],
    );
  }

  Widget _buildDetailsContent(bool isTablet, Size size) {
    final details = <String, String?>{
      'Roll No': roll,
      'Designation': designation,
      'Year': year,
      'Branch': branch,
      'Phone': phone,
      'Status': status,
    };

    final availableDetails =
        details.entries
            .where((entry) => entry.value?.isNotEmpty ?? false)
            .toList();

    if (availableDetails.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color(0xff1A233A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withAlpha(77)),
        ),
        child: Column(
          children: [
            Icon(Icons.info_outline, color: Colors.grey[400], size: 32),
            const SizedBox(height: 12),
            Text(
              'No Additional Details',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Additional profile information will appear here when available',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Column(
      children:
          availableDetails.asMap().entries.map((meow) {
            final index = meow.key;
            final detail = meow.value;
            final isLast = index == availableDetails.length - 1;

            return Column(
              children: [
                ProfileInfoRow(
                  title: detail.key,
                  value: detail.value!,
                  index: index,
                ),
                if (!isLast)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFFE5A122).withAlpha(77),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String title;
  final String value;
  final int index;

  const ProfileInfoRow({
    super.key,
    required this.title,
    required this.value,
    required this.index,
  });

  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'roll no':
        return Icons.badge_outlined;
      case 'designation':
        return Icons.work_outline;
      case 'year':
        return Icons.calendar_today_outlined;
      case 'branch':
        return Icons.school_outlined;
      case 'phone':
        return Icons.phone_outlined;
      case 'status':
        return Icons.verified_user_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'roll no':
        return Colors.blue;
      case 'designation':
        return Colors.green;
      case 'year':
        return Colors.orange;
      case 'branch':
        return Colors.purple;
      case 'phone':
        return Colors.teal;
      case 'status':
        return Color(0xFFE5A122);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForTitle(title);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff1A233A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(38),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_getIconForTitle(title), color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.check_circle_outline, color: color, size: 16),
          ),
        ],
      ),
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
