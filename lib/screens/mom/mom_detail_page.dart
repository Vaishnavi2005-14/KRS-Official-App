import 'package:flutter/material.dart';
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
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: orangeColor),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
            vertical: width * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                  shadows: const [Shadow(blurRadius: 10, color: orangeColor)],
                ),
              ),

              const SizedBox(height: 10),
              Text(widget.date, style: const TextStyle(color: Colors.white70)),
              const Divider(color: orangeColor, thickness: 1),
              const SizedBox(height: 16),

              // Meeting Type
              Text(
                "Meeting Type",
                style: TextStyle(color: orangeColor, fontSize: width * 0.045),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: orangeColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.meetingType,
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // Link
              Text(
                "Link",
                style: TextStyle(color: orangeColor, fontSize: width * 0.045),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap:
                    () => launchUrl(
                      Uri.parse(widget.meetingLink),
                      mode: LaunchMode.externalApplication,
                    ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: orangeColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.meetingLink,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Domains
              Text(
                "Domains",
                style: TextStyle(color: orangeColor, fontSize: width * 0.045),
              ),
              const SizedBox(height: 10),
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

              const SizedBox(height: 120),

              // Uploaded by
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Uploaded by",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
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

              const SizedBox(height: 20),

              // Buttons
              if (_isAdmin) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _iconCircleButton(Icons.edit, () async {
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

                      if (result == true) {
                        // Fetch updated MoM by ID from provider
                        await Provider.of<MoMProvider>(
                          context,
                          listen: false,
                        ).loadMoMs();
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
                    }),
                    const SizedBox(width: 30),
                    _iconCircleButton(Icons.delete, () async {
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
                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));
                            if (message == "MoM deleted successfully") {
                              Navigator.pop(context, true);
                            } // Go back to previous screen after deletion
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      }
                    }),
                  ],
                ),
              ],
              const SizedBox(height: 20),
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
