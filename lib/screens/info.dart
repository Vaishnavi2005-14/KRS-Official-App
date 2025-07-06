import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  static const orangeColor = Color(0xFFE5A122);
  static const bgColor = Color(0xff040E1E);
  static const cardColor = Color(0xff06132A);
  static const bugReportURL =
      'https://docs.google.com/forms/d/e/1FAIpQLScbqnmkvkbJbjwgATx8eEiKumtITa9wQbzYZuG0PsGKkfbEUQ/viewform?usp=dialog';

  void _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(
        msg: 'Could not launch $url',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'ABOUT US',
              style: TextStyle(
                color: orangeColor,
                fontSize: isTablet ? 28 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(isTablet ? 10 : 8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(26),
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
        backgroundColor: bgColor,
        elevation: 0,
        toolbarHeight: isTablet ? 70 : 56,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: isTablet ? 28 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor, cardColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.06),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cardColor, Color(0xff0A1A35)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
                  border: Border.all(
                    color: orangeColor.withAlpha(51),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: orangeColor.withAlpha(26),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            orangeColor.withAlpha(26),
                            orangeColor.withAlpha(51),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: orangeColor.withAlpha(128),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: screenWidth * (isTablet ? 0.12 : 0.15),
                        backgroundImage: const AssetImage('assets/logo.png'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'KIIT Robotics Society',
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 26,
                        fontWeight: FontWeight.bold,
                        color: orangeColor,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: orangeColor.withAlpha(128),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor.withAlpha(128),
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        border: Border.all(
                          color: Colors.grey.withAlpha(51),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'A fusion of minds where creativity meets code,\nKRS paves innovations\' road.',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          color: Colors.grey[300],
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Contact Information
              _buildInfoCard(
                icon: Icons.email_outlined,
                label: 'Email Us',
                value: 'robotics.society@kiit.ac.in',
                onTap:
                    () => _launchURL(
                      context,
                      'mailto:robotics.society@kiit.ac.in',
                    ),
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),

              SizedBox(height: screenHeight * 0.02),

              _buildInfoCard(
                icon: Icons.location_on_outlined,
                label: 'Visit Us',
                value: 'Campus 6, KIIT University, Bhubaneswar',
                onTap:
                    () => _launchURL(
                      context,
                      'https://www.google.com/maps/place/KIIT+Robotics+Society/@20.355509,85.820066,17z/data=!4m6!3m5!1s0x3a1908c555555555:0x35232e5ac74b6dc3!8m2!3d20.3555094!4d85.8200663!16s%2Fg%2F11sfg889nd?hl=en&entry=ttu&g_ep=EgoyMDI1MDYxNi4wIKXMDSoASAFQAw%3D%3D',
                    ),
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),

              SizedBox(height: screenHeight * 0.03),

              // Social Media Section
              Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cardColor, Color(0xff0A1A35)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  border: Border.all(
                    color: orangeColor.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isTablet ? 10 : 8),
                          decoration: BoxDecoration(
                            color: orangeColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.connect_without_contact,
                            color: orangeColor,
                            size: isTablet ? 24 : 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Connect With Us',
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: orangeColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialButton(
                          icon: FontAwesomeIcons.facebookF,
                          onPressed:
                              () => _launchURL(
                                context,
                                'https://www.facebook.com/share/15JkdWEtz5/',
                              ),
                          isTablet: isTablet,
                        ),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.instagram,
                          onPressed:
                              () => _launchURL(
                                context,
                                'https://www.instagram.com/kiit_robotics.society?igsh=bnFhM3EzMWg1YW1u',
                              ),
                          isTablet: isTablet,
                        ),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.youtube,
                          onPressed:
                              () => _launchURL(
                                context,
                                'https://www.youtube.com/c/KIITROBOTICSSOCIETY',
                              ),
                          isTablet: isTablet,
                        ),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.linkedinIn,
                          onPressed:
                              () => _launchURL(
                                context,
                                'https://www.linkedin.com/company/kiit-robotics-society-bbsr',
                              ),
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Bug Report Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withAlpha(26),
                      Colors.red.withAlpha(13),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  border: Border.all(
                    color: Colors.red.withAlpha(128),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.bug_report_outlined,
                      color: Colors.red[400],
                      size: isTablet ? 40 : 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Found a bug?',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Help us improve by reporting issues',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () => _launchURL(context, bugReportURL),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                          vertical: isTablet ? 16 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 10,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.report_problem_outlined,
                            color: Colors.white,
                            size: isTablet ? 20 : 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Report Bug',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Footer
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Made with ',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: isTablet ? 14 : 13,
                        ),
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.red[400],
                        size: isTablet ? 18 : 16,
                      ),
                      Text(
                        ' by KRS App Dev Team',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: isTablet ? 14 : 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: orangeColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: orangeColor.withAlpha(51),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '© Copyright 2025 | KRS',
                      style: TextStyle(
                        color: orangeColor,
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cardColor, Color(0xff0A1A35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: orangeColor.withAlpha(51), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 12 : 10),
                  decoration: BoxDecoration(
                    color: orangeColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                    border: Border.all(
                      color: orangeColor.withAlpha(51),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: orangeColor,
                    size: isTablet ? 24 : 20,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: orangeColor,
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: orangeColor.withAlpha(128),
                  size: isTablet ? 18 : 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [bgColor, Color(0xff0A1A35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: orangeColor.withAlpha(51), width: 1),
        boxShadow: [
          BoxShadow(
            color: orangeColor.withAlpha(26),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: CircleBorder(),
          child: Container(
            padding: EdgeInsets.all(isTablet ? 14 : 12),
            child: FaIcon(icon, color: orangeColor, size: isTablet ? 22 : 18),
          ),
        ),
      ),
    );
  }
}
