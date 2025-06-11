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
      if (isSelected) {
        selectedDomains.add(domain);
      } else {
        selectedDomains.remove(domain);
      }
    });
  }

  void _onTypeChanged(String newType) {
    setState(() {
      selectedType = newType;
    });
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MoMFormWidgets.buildTitle(width),
              const SizedBox(height: 30),
              
              MoMFormWidgets.buildLabel('MoM TITLE'),
              MoMFormWidgets.buildTextField(titleController, 'Enter title...'),
              
              MoMFormWidgets.buildLabel('MoM LINK'),
              MoMFormWidgets.buildTextField(linkController, 'Enter link...'),
              
              MoMFormWidgets.buildLabel('SELECT DOMAINS'),
              MoMFormWidgets.buildDomainSelector(
                selectedDomains: selectedDomains,
                onDomainChanged: _onDomainChanged,
              ),
              
              MoMFormWidgets.buildLabel('MoM TYPE'),
              MoMFormWidgets.buildMeetingTypeDropdown(
                selectedType: selectedType,
                onTypeChanged: _onTypeChanged,
              ),
              
              const SizedBox(height: 30),
              MoMFormWidgets.buildUploadButton(
                isLoading: _isLoading,
                onPressed: _uploadMoM,
              ),
            ],
          ),
        ),
      ),
    );
  }
}