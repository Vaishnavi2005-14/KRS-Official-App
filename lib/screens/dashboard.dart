import 'package:flutter/material.dart';
import 'package:krs_app/providers/notice_provider.dart';
import 'package:krs_app/screens/attendance/animated_text.dart';
import 'package:krs_app/screens/attendance/attendance_home.dart';
import 'package:krs_app/screens/mom/mom_view_page.dart';
import 'package:krs_app/services/auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krs_app/screens/info.dart';
import 'package:provider/provider.dart';

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
                  SizedBox(height: screenHeight * 0.025),
                  _buildDashboardCard(
                    title: "Notice",
                    subtitle: "Upload Notices",
                    icon: Icons.file_upload_outlined,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isTablet: isTablet,
                    onTap: () {
                      final TextEditingController titleController =
                          TextEditingController();
                      final TextEditingController descController =
                          TextEditingController();
                      final TextEditingController linkController =
                          TextEditingController();
                      const int descMaxLength = 100;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          bool isUploading = false;
                          String? errorText;

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(
                                    color: Color(0xFFE5A122),
                                    width: 1.5,
                                  ),
                                ),
                                backgroundColor: Color(0xff06132A),
                                elevation: 12,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                    horizontal: 20,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Top icon
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xFFE5A122,
                                            ).withOpacity(0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(14),
                                          child: Icon(
                                            Icons.file_upload_outlined,
                                            size: 38,
                                            color: Color(0xFFE5A122),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Upload Notice",
                                          style: TextStyle(
                                            color: Color(0xFFE5A122),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(height: 18),
                                        // Title field
                                        TextField(
                                          controller: titleController,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            labelText: "Title",
                                            labelStyle: TextStyle(
                                              color: Color(0xFFE5A122),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.title,
                                              color: Color(0xFFE5A122),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xff1A233A),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Color(0xFFE5A122),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Color(0xFFE5A122),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 14),
                                        // Description field with counter
                                        TextField(
                                          controller: descController,
                                          style: TextStyle(color: Colors.white),
                                          maxLines: 3,
                                          maxLength: descMaxLength,
                                          decoration: InputDecoration(
                                            labelText: "Description",
                                            labelStyle: TextStyle(
                                              color: Color(0xFFE5A122),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.description,
                                              color: Color(0xFFE5A122),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xff1A233A),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Color(0xFFE5A122),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Color(0xFFE5A122),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            counterStyle: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 14),
                                        // Link field
                                        TextField(
                                          controller: linkController,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            labelText:
                                                "Attachment Link (optional)",
                                            labelStyle: TextStyle(
                                              color: Color(0xFFE5A122),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.link,
                                              color: Color(0xFFE5A122),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xff1A233A),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Color(0xFFE5A122),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Color(0xFFE5A122),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            suffixIcon: Tooltip(
                                              message:
                                                  "Paste a valid document or web link",
                                              child: Icon(
                                                Icons.info_outline,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (errorText != null) ...[
                                          SizedBox(height: 14),
                                          Text(
                                            errorText!,
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                        SizedBox(height: 22),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed:
                                                    isUploading
                                                        ? null
                                                        : () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  side: BorderSide(
                                                    color: Colors.grey[600]!,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                                child: Text("Cancel"),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed:
                                                    isUploading
                                                        ? null
                                                        : () async {
                                                          setState(() {
                                                            errorText = null;
                                                            isUploading = true;
                                                          });
                                                          if (titleController
                                                                  .text
                                                                  .trim()
                                                                  .isEmpty ||
                                                              descController
                                                                  .text
                                                                  .trim()
                                                                  .isEmpty) {
                                                            setState(() {
                                                              errorText =
                                                                  "Title and Description are required.";
                                                              isUploading =
                                                                  false;
                                                            });
                                                            return;
                                                          }
                                                          try {
                                                            final provider =
                                                                Provider.of<
                                                                  NoticeProvider
                                                                >(
                                                                  context,
                                                                  listen: false,
                                                                );
                                                            await provider.uploadNotice(
                                                              title:
                                                                  titleController
                                                                      .text
                                                                      .trim(),
                                                              description:
                                                                  descController
                                                                      .text
                                                                      .trim(),
                                                              attachmentLink:
                                                                  linkController
                                                                          .text
                                                                          .trim()
                                                                          .isEmpty
                                                                      ? null
                                                                      : linkController
                                                                          .text
                                                                          .trim(),
                                                            );
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color:
                                                                          Colors
                                                                              .greenAccent,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Text(
                                                                      "Notice uploaded successfully!",
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.white,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                backgroundColor:
                                                                    Color(
                                                                      0xff194DA6,
                                                                    ),
                                                              ),
                                                            );
                                                          } catch (e) {
                                                            setState(() {
                                                              errorText = e
                                                                  .toString()
                                                                  .replaceFirst(
                                                                    'Exception: ',
                                                                    '',
                                                                  );
                                                              isUploading =
                                                                  false;
                                                            });
                                                          }
                                                        },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(
                                                    0xFFE5A122,
                                                  ),
                                                  foregroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  elevation: 2,
                                                ),
                                                child:
                                                    isUploading
                                                        ? SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2.5,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                  Color
                                                                >(Colors.black),
                                                          ),
                                                        )
                                                        : Text("Upload"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.025),
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
