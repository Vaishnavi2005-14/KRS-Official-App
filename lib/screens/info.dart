import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  static const textColor = Color(0xFFE5A122);
  static const bugReportURL =
      'https://docs.google.com/forms/d/e/1FAIpQLScbqnmkvkbJbjwgATx8eEiKumtITa9wQbzYZuG0PsGKkfbEUQ/viewform?usp=dialog';

  void _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Made with ',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Icon(Icons.favorite, color: Colors.redAccent, size: 16),
              Text(
                ' by KRS App Dev Team',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            //color: Colors.black,
            child: const Text(
              ' © Copyright@2025 | KRS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFE5A122),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Card(
          color: Colors.white10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                CircleAvatar(
                  radius: width * 0.15,
                  backgroundImage: const AssetImage('assets/logo.png'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 25),
                const Text(
                  'KIIT Robotics Society',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  '''A fusion of minds where creativity meets code,
KRS paves innovations' road.''',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildInfoCard(
                  icon: Icons.email,
                  label: 'robotics.society@kiit.ac.in',
                  onTap:
                      () => _launchURL(
                        context,
                        'mailto:robotics.society@kiit.ac.in',
                      ),
                ),
                const SizedBox(height: 10),
                _buildInfoCard(
                  icon: Icons.location_on,
                  label:
                      '12, KIIT Campus 6 Rd, Chandaka Industrial Estate, Patia, Bhubaneswar, Odisha 751024',
                  onTap:
                      () => _launchURL(
                        context,
                        'https://www.google.com/maps/place/KIIT+Robotics+Society/@20.355509,85.820066,17z/data=!4m6!3m5!1s0x3a1908c555555555:0x35232e5ac74b6dc3!8m2!3d20.3555094!4d85.8200663!16s%2Fg%2F11sfg889nd?hl=en&entry=ttu&g_ep=EgoyMDI1MDYxNi4wIKXMDSoASAFQAw%3D%3D',
                      ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Follow us on',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  children: [
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.facebookF,
                        color: textColor,
                      ),
                      onPressed:
                          () => _launchURL(
                            context,
                            'https://www.facebook.com/share/15JkdWEtz5/',
                          ),
                    ),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.instagram,
                        color: textColor,
                      ),
                      onPressed:
                          () => _launchURL(
                            context,
                            'https://www.instagram.com/kiit_robotics.society?igsh=bnFhM3EzMWg1YW1u',
                          ),
                    ),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.youtube,
                        color: textColor,
                      ),
                      onPressed:
                          () => _launchURL(
                            context,
                            'https://www.youtube.com/c/KIITROBOTICSSOCIETY',
                          ),
                    ),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.linkedinIn,
                        color: textColor,
                      ),
                      onPressed:
                          () => _launchURL(
                            context,
                            'https://www.linkedin.com/company/kiit-robotics-society-bbsr',
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Found a bug?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton.icon(
                        onPressed: () => _launchURL(context, bugReportURL),
                        icon: const Icon(Icons.bug_report, color: Colors.black),
                        label: const Text('Report Bug'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: textColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final width = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListTile(
          leading: Icon(icon, color: textColor),
          title: Text(
            label,
            style: TextStyle(color: textColor, fontSize: width * 0.04),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
