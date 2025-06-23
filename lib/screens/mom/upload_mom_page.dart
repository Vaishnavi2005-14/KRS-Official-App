import 'package:flutter/material.dart';
import '../../services/mom_service.dart';
import '../../widgets/mom/upload_mom/app_constants.dart';
import '../../widgets/mom/upload_mom/mom_form_widgets.dart';

class UploadMoMPage extends StatefulWidget {
  const UploadMoMPage({super.key});

  @override
  State<UploadMoMPage> createState() => _UploadMoMPageState();
}

class _UploadMoMPageState extends State<UploadMoMPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final linkController = TextEditingController();

  String selectedType = 'Scrum';
  List<String> selectedDomains = [];
  bool _isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void _onDomainChanged(String domain, bool isSelected) {
    setState(() {
      isSelected ? selectedDomains.add(domain) : selectedDomains.remove(domain);
    });
  }

  void _onTypeChanged(String newType) {
    setState(() => selectedType = newType);
  }

  Future<void> _uploadMoM() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDomains.isEmpty) {
      _showMessage('Please select at least one domain');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final message = await MoMService.uploadMoM(
        title: titleController.text.trim(),
        docLink: linkController.text.trim(),
        domains: selectedDomains.map((d) => d.trim().toLowerCase()).toList(),
        meetType: selectedType.toLowerCase().replaceAll(' ', '-'),
      );

      _showMessage(message);
      if (message.toLowerCase().contains("success")) {
        _resetForm();
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showMessage('An error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    setState(() {
      titleController.clear();
      linkController.clear();
      selectedDomains.clear();
      selectedType = 'Scrum';
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Upload new MoM',
          style: TextStyle(
            color: const Color(0xFFE5A122),
            fontSize: width * 0.07,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Divider right below AppBar
            Divider(
              color:Color(0xFFE5A122),
              thickness: 2,
              height: 5,
            ),
            const SizedBox(height: 20),

            // Card layout for form
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color:Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MoMFormWidgets.buildLabel('MoM TITLE'),
                    const SizedBox(height: 4),
                    MoMFormWidgets.buildTextField(titleController, 'Enter title...'),
                    const SizedBox(height: 10),

                    MoMFormWidgets.buildLabel('MoM LINK'),
                    const SizedBox(height: 4),
                    MoMFormWidgets.buildTextField(linkController, 'Enter link...'),
                    const SizedBox(height: 10),

                    MoMFormWidgets.buildLabel('SELECT DOMAINS (you can select 1 or more)'),
                    const SizedBox(height: 3),
                    MoMFormWidgets.buildDomainSelector(
                      selectedDomains: selectedDomains,
                      onDomainChanged: _onDomainChanged,
                    ),
                    const SizedBox(height: 4),

                    MoMFormWidgets.buildLabel('MoM TYPE'),
                    const SizedBox(height: 4),
                    MoMFormWidgets.buildMeetingTypeDropdown(
                      selectedType: selectedType,
                      onTypeChanged: _onTypeChanged,
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: MoMFormWidgets.buildUploadButton(
                        isLoading: _isLoading,
                        onPressed: _uploadMoM,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
