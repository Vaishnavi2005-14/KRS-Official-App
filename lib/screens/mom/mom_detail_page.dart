import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/providers/mom_provider.dart';
import 'edit_mom_page.dart';
import 'package:krs_app/services/mom_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:krs_app/services/auth.dart';

const Color bgColor = Color(0xFF06142E);
const Color orangeColor = Color(0xFFE5A122);

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
    final s = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: s.width * 0.06,
            vertical: s.height * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: s.width * 0.09,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                  shadows: const [Shadow(blurRadius: 10, color: orangeColor)],
                ),
              ),

              SizedBox(height: s.height * 0.01),
              Text(
                widget.date,
                style: const TextStyle(
                  color: Color(0xff865D10),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(color: Color(0xff865D10), thickness: 2),
              SizedBox(height: s.height * 0.01),

              // Meeting Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Meeting Type",
                    style: TextStyle(
                      color: orangeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: s.width * 0.045,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff151E2D),
                      border: Border.all(color: orangeColor),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      widget.meetingType,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              SizedBox(height: s.height * 0.04),

              // Link
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Link",
                    style: TextStyle(
                      color: orangeColor,
                      fontSize: s.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  GestureDetector(
                    onTap:
                        () => launchUrl(
                          Uri.parse(widget.meetingLink),
                          mode: LaunchMode.externalApplication,
                        ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xff151E2D),
                        border: Border.all(color: orangeColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "MoM Link",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: s.height * 0.05),

              // Domains
              Text(
                "Domains",
                style: TextStyle(
                  color: orangeColor,
                  fontSize: s.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: s.height * 0.01),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    widget.domains
                        .map(
                          (domain) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: orangeColor),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              domain,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
              ),

              SizedBox(height: s.height * 0.15),

              // Uploaded by
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Uploaded by",
                      style: TextStyle(color: orangeColor),
                    ),
                    SizedBox(height: s.height * 0.01),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: orangeColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.uploadedBy,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: s.height * 0.04),

              // Buttons
              if (_isAdmin) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _iconCircleButton(Icons.edit_outlined, () async {
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
                        await Provider.of<MoMProvider>(
                          context,
                          listen: false,
                        ).loadMoMs();
                        if (context.mounted) {
                          final updatedMoM = Provider.of<MoMProvider>(
                            context,
                            listen: false,
                          ).momList.firstWhere((m) => m['id'] == widget.id);

                          // Replace this page with updated version

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
                                    domains: List<String>.from(
                                      updatedMoM['domains'],
                                    ),
                                    meetingLink: updatedMoM['meetingLink'],
                                    id: updatedMoM['id'],
                                  ),
                            ),
                          );
                        }
                      }
                    }),
                    SizedBox(width: 30),
                    _iconCircleButton(Icons.delete_outline, () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text("Delete MoM?"),
                              content: const Text(
                                "Are you sure you want to delete this MoM? This action cannot be undone.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        try {
                          final message = await MoMService.deleteMoM(widget.id);
                          Fluttertoast.showToast(
                            msg: message,
                            backgroundColor: Colors.green,
                            toastLength: Toast.LENGTH_LONG,
                          );
                          if (message == "MoM deleted successfully" &&
                              context.mounted) {
                            Navigator.pop(context, true);
                          } // Go back to previous screen after deletion
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: e.toString(),
                            backgroundColor: Colors.red,
                            toastLength: Toast.LENGTH_LONG,
                          );
                        }
                      }
                    }),
                  ],
                ),
              ],
              SizedBox(height: s.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: orangeColor, width: 1),
        ),
        child: Icon(icon, color: orangeColor, size: 24),
      ),
    );
  }
}
