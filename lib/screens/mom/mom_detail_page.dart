import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/providers/mom_provider.dart';
import 'edit_mom_page.dart';
import 'package:krs_app/services/mom_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:krs_app/services/auth.dart';

class MoMDetailPage extends StatefulWidget {
  final String title;
  final String date;
  final String uploadedBy;
  final String meetingType;
  final List<String> domains;
  final String meetingLink;
  final String id;

  const MoMDetailPage({
    super.key,
    required this.title,
    required this.date,
    required this.uploadedBy,
    required this.meetingType,
    required this.domains,
    required this.meetingLink,
    required this.id,
  });

  @override
  State<MoMDetailPage> createState() => _MoMDetailPageState();
}

class _MoMDetailPageState extends State<MoMDetailPage> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await AuthService().isAdmin();
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'MOM DETAILS',
              style: TextStyle(
                color: Color(0xFFE5A122),
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
                Icons.description,
                color: Colors.white,
                size: isTablet ? 28 : 24,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff040E1E),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(screenWidth, screenHeight, isTablet),
              SizedBox(height: screenHeight * 0.03),
              _buildInfoSection(screenWidth, screenHeight, isTablet),
              SizedBox(height: screenHeight * 0.03),
              _buildDomainsSection(screenWidth, screenHeight, isTablet),
              SizedBox(height: screenHeight * 0.04),
              _buildUploadedBySection(screenWidth, screenHeight, isTablet),
              if (_isAdmin) ...[
                SizedBox(height: screenHeight * 0.04),
                _buildActionButtons(screenWidth, screenHeight, isTablet),
              ],
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: Color(0xFFE5A122).withAlpha(128), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: Color(0xFFE5A122),
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            widget.date,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Column(
      children: [
        _buildInfoRow(
          'Meeting Type',
          widget.meetingType,
          Icons.meeting_room,
          screenWidth,
          screenHeight,
          isTablet,
        ),
        SizedBox(height: screenHeight * 0.02),
        _buildLinkRow(screenWidth, screenHeight, isTablet),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: Colors.grey.withAlpha(78), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 10),
            decoration: BoxDecoration(
              color: Color(0xFFE5A122).withAlpha(51),
              borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
            ),
            child: Icon(
              icon,
              color: Color(0xFFE5A122),
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
                    color: Color(0xFFE5A122),
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12 : 10,
                    vertical: isTablet ? 8 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff040E1E),
                    borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                    border: Border.all(color: Color(0xFFE5A122), width: 1),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(double screenWidth, double screenHeight, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: Colors.grey.withAlpha(78), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 10),
            decoration: BoxDecoration(
              color: Color(0xFFE5A122).withAlpha(51),
              borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
            ),
            child: Icon(
              Icons.link,
              color: Color(0xFFE5A122),
              size: isTablet ? 24 : 20,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MoM Link',
                  style: TextStyle(
                    color: Color(0xFFE5A122),
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                GestureDetector(
                  onTap:
                      () => launchUrl(
                        Uri.parse(widget.meetingLink),
                        mode: LaunchMode.externalApplication,
                      ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12 : 10,
                      vertical: isTablet ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff040E1E),
                      borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                      border: Border.all(color: Color(0xFFE5A122), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Open Link',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.open_in_new,
                          color: Color(0xFFE5A122),
                          size: isTablet ? 16 : 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainsSection(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: Colors.grey.withAlpha(78), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 8 : 6),
                decoration: BoxDecoration(
                  color: Color(0xFFE5A122).withAlpha(51),
                  borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                ),
                child: Icon(
                  Icons.category,
                  color: Color(0xFFE5A122),
                  size: isTablet ? 20 : 18,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                'Domains',
                style: TextStyle(
                  color: Color(0xFFE5A122),
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                widget.domains.map((domain) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12 : 10,
                      vertical: isTablet ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff040E1E),
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                      border: Border.all(color: Color(0xFFE5A122), width: 1),
                    ),
                    child: Text(
                      domain,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedBySection(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: Colors.grey.withAlpha(78), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 8 : 6),
                decoration: BoxDecoration(
                  color: Color(0xFFE5A122).withAlpha(51),
                  borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                ),
                child: Icon(
                  Icons.person,
                  color: Color(0xFFE5A122),
                  size: isTablet ? 20 : 18,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                'Uploaded by',
                style: TextStyle(
                  color: Color(0xFFE5A122),
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 12,
              vertical: isTablet ? 10 : 8,
            ),
            decoration: BoxDecoration(
              color: Color(0xff040E1E),
              borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
              border: Border.all(color: Color(0xFFE5A122), width: 1),
            ),
            child: Text(
              widget.uploadedBy,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.edit,
          label: 'Edit',
          color: Color(0xFFE5A122),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EditMoMPage(
                      momId: widget.id,
                      initialTitle: widget.title,
                      initialLink: widget.meetingLink,
                      initialType: widget.meetingType,
                      initialDomains: widget.domains,
                    ),
              ),
            );

            if (result == true && context.mounted) {
              await Provider.of<MoMProvider>(context, listen: false).loadMoMs();
              if (context.mounted) {
                final updatedMoM = Provider.of<MoMProvider>(
                  context,
                  listen: false,
                ).momList.firstWhere((m) => m['id'] == widget.id);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MoMDetailPage(
                          title: updatedMoM['title'],
                          date: updatedMoM['date'],
                          uploadedBy:
                              updatedMoM['uploadedBy'] is Map
                                  ? updatedMoM['uploadedBy']['name']
                                  : updatedMoM['uploadedBy'],
                          meetingType: updatedMoM['meetingType'],
                          domains: List<String>.from(updatedMoM['domains']),
                          meetingLink: updatedMoM['meetingLink'],
                          id: updatedMoM['id'],
                        ),
                  ),
                );
              }
            }
          },
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          isTablet: isTablet,
        ),
        _buildActionButton(
          icon: Icons.delete,
          label: 'Delete',
          color: Colors.red,
          onTap: () => _showDeleteDialog(),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: color.withAlpha(51),
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: isTablet ? 20 : 18),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    final momProvider = Provider.of<MoMProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => Dialog(
            backgroundColor: Color(0xff06132A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
            ),
            child: Container(
              width: isTablet ? screenWidth * 0.5 : screenWidth * 0.8,
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: isTablet ? 60 : 48,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Delete MoM?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Are you sure you want to delete this MoM? This action cannot be undone.',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 18 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey, width: 1),
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 12 : 8,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
            
                            Navigator.pop(dialogContext);

                            try {
                              final message = await MoMService.deleteMoM(
                                widget.id,
                              );

                              if (message == "MoM deleted successfully") {
                                Fluttertoast.showToast(
                                  msg: message,
                                  backgroundColor: Colors.green,
                                  toastLength: Toast.LENGTH_LONG,
                                );
                                await momProvider.loadMoMs();

                                if (mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: message,
                                  backgroundColor: Colors.red,
                                  toastLength: Toast.LENGTH_LONG,
                                );
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: 'Failed to delete MoM: ${e.toString()}',
                                backgroundColor: Colors.red,
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 12 : 8,
                              ),
                            ),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 14,
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
    );
  }
}
