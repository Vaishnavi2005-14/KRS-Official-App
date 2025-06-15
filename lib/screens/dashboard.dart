import 'package:flutter/material.dart';
import 'package:krs_app/screens/animated_text.dart';
import 'package:krs_app/screens/attendance_home.dart';
import 'package:krs_app/services/auth.dart';
import 'package:flutter_svg/svg.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isAdmin = false;
  String _name = '';

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _loadUserName();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await AuthService().isAdmin();
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  Future<void> _loadUserName() async {
    AuthService().getUserName().then((value) {
      setState(() {
        _name = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'DASHBOARD',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: isTablet ? 28 : 24,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: Color(0xFFE5A122),
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   toolbarHeight: isTablet ? 70 : 56,
      // ),
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
              Container(
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
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Container(
          //   height: screenWidth * 0.03,
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     color: Color(0xFFE5A122),
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(isTablet ? 20 : 20),
          //       bottomRight: Radius.circular(isTablet ? 20 : 20),
          //     ),
          //   ),
          // ),
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
                        Text(
                          "Welcome, $_name!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 32 : screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.008),
                        // Text(
                        //   "What would you like to do today?",
                        //   style: TextStyle(
                        //     color: Colors.grey[400],
                        //     fontSize: isTablet ? 17 : screenWidth * 0.038,
                        //   ),
                        // ),
                        AnimatedLanguageText(
                          texts: [
                            "What would you like to do today?",
                            "आज आप क्या करना पसंद करेंगे?",
                            "अद्य भवान् किमर्थं कर्तुम् इच्छति?",
                            "আপনি আজ কি করতে চান?",
                          ],
                          typingSpeed: Duration(milliseconds: 50),
                          pauseDuration: Duration(seconds: 3),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.04),
                // Container(
                //   width: double.infinity,
                //   child: Image.asset('assets/robot.png', fit: BoxFit.cover),
                // ),
                // if (_isAdmin) ...[
                //   _buildDashboardCard(
                //     title: "Attendance",
                //     subtitle: "Mark and manage student attendance",
                //     icon: Icons.people_outline,
                //     screenWidth: screenWidth,
                //     screenHeight: screenHeight,
                //     isTablet: isTablet,
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => AttendanceHomePage(),
                //         ),
                //       );
                //     },
                //   ),
                //   SizedBox(height: screenHeight * 0.025),
                // ],
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
                _buildDashboardCard(
                  title: "Minutes of Meeting",
                  subtitle: "View and edit MoM",
                  icon: Icons.person_outline,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isTablet: isTablet,
                  onTap: () {
                    // saalo idhar likhna
                  },
                ),
              ],
            ),
          ),
        ],
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
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 16 : 14,
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
