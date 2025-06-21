import 'package:flutter/material.dart';
import 'package:krs_app/screens/animated_text.dart';
import 'package:krs_app/screens/attendance/attendance_home.dart';
import 'package:krs_app/screens/info.dart';
import 'package:krs_app/screens/member_management/member_management_hub.dart';
import 'package:krs_app/screens/mom/mom_view_page.dart';
import 'package:krs_app/services/auth.dart';
import 'package:flutter_svg/svg.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _name = '';
  String _userDesignation = '';
  bool _isSuperUser = false;
  bool _isPrivilegedAdminOperationsUser = false;

  @override
  void initState() {
    super.initState();
    _checkSuperUser();
    _checkPrivilegedAdminOperationsUser();
    _loadUserName();
    _loadUserDesignation();
  }

  Future<void> _checkSuperUser() async {
    final isSuperUser = await AuthService().isSuperUser();
    setState(() {
      _isSuperUser = isSuperUser;
    });
  }

  Future<void> _checkPrivilegedAdminOperationsUser() async {
    final isPrivilegedAdminOperationsUser =
        await AuthService().isPrivilegedAdminOperationsUser();
    setState(() {
      _isPrivilegedAdminOperationsUser = isPrivilegedAdminOperationsUser;
    });
  }

  Future<void> _loadUserName() async {
    AuthService().getUserName().then((value) {
      setState(() {
        _name = value;
      });
    });
  }

  Future<void> _loadUserDesignation() async {
    AuthService().getUserDesignation().then((value) {
      setState(() {
        _userDesignation = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 5),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            title: Row(
              children: [
                Container(
                  width: isTablet ? 110 : 55,
                  height: isTablet ? 130 : 65,
                  padding: EdgeInsets.all(4),
                  child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                ),
                Container(
                  width: isTablet ? 140 : 75,
                  height: isTablet ? 200 : 100,
                  padding: EdgeInsets.all(3),
                  child: SvgPicture.asset(
                    'assets/kiitlogo.svg',
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.contain,
                    placeholderBuilder:
                        (context) => Container(
                          color: Colors.white.withOpacity(0.2),
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                            size: isTablet ? 20 : 16,
                          ),
                        ),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                  width: isTablet ? 40 : 55,
                  height: isTablet ? 30 : 65,
                  padding: EdgeInsets.all(4),
                  child: Image.asset('assets/ksac.png', fit: BoxFit.contain),
                ),
                SizedBox(width: 4),
              ],
            ),
            backgroundColor: Color(0xFFE5A122),
            elevation: 0,
            toolbarHeight: isTablet ? 70 : 56,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InfoPage()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.all(isTablet ? 10 : 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: isTablet ? 28 : 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: screenWidth * 0.10,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: isTablet ? 40 : 80,
                        height: isTablet ? 30 : 80,
                        padding: EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/robot1.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Welcome, $_name!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 32 : screenWidth * 0.065,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          AnimatedLanguageText(
                            texts: [
                              "What would you like to do today?",
                              "आज आप क्या करना पसंद करेंगे?",
                              "अद्य भवान् किमर्थं कर्तुम् इच्छति?",
                              "আপনি আজ কি করতে চান?",
                              "మీరు ఈ రోజు ఏమి చేయాలనుకుంటున్నారు?",
                              "ଆପଣ ଆଜି କଣ କରିବାକୁ ଚାହାଁଛନ୍ତି?",
                              "तपाईं आज के गर्न चाहनुहुन्छ?",
                              "ਤੁਸੀਂ ਅੱਜ ਕੀ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?",
                              "तुम्हाला आज काय करायचं आहे?",
                              "Aji apuni ki koribole mon ase?",
                              "আপুনি আজি কি কৰিব বিচাৰে?",
                            ],
                            typingSpeed: Duration(milliseconds: 50),
                            pauseDuration: Duration(seconds: 2),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFE5A122),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _userDesignation.isNotEmpty
                            ? _userDesignation
                            : "Loading...",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isTablet ? 12 : 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  if (_isSuperUser) ...[
                    _buildDashboardCard(
                      title: "Member Management",
                      subtitle: "Manage member approvals and roles",
                      icon: Icons.admin_panel_settings,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      isTablet: isTablet,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberManagementHub(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.025),
                  ],
                  if (_isPrivilegedAdminOperationsUser) ...[
                    _buildDashboardCard(
                      title: "Attendance",
                      subtitle: "Mark and manage student attendance",
                      icon: Icons.people_outline,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      isTablet: isTablet,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceHomePage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.025),
                  ],

                  _buildDashboardCard(
                    title: "Minutes of Meeting",
                    subtitle: "View and edit MoM",
                    icon: Icons.library_books_outlined,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isTablet: isTablet,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MoMViewPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          color: Color(0xff06132A),
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          border: Border.all(
            color: Color(0xFFE5A122).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: Color(0xFFE5A122).withOpacity(0.2),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
              ),
              child: Icon(
                icon,
                color: Color(0xFFE5A122),
                size: isTablet ? 30 : 24,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          isTablet ? screenWidth * 0.06 : screenWidth * 0.048,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 16 : screenWidth * 0.04,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFE5A122),
              size: isTablet ? 20 : 16,
            ),
          ],
        ),
      ),
    );
  }
}
