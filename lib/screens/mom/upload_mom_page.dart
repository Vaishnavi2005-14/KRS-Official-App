import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/widgets/mom/edit_mom/constants_file.dart';
import '../../services/mom_service.dart';
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
  void initState() {
    super.initState();
    if (selectedType == 'Scrum') {
      selectedDomains = List.from(AppConstants.domains);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    linkController.dispose();
    super.dispose();
  }

  // New callback for domain dialog
  void _onDomainsChanged(List<String> newDomains) {
    setState(() {
      selectedDomains = newDomains;
    });
  }

  void _onTypeChanged(String newType) {
    setState(() {
      selectedType = newType;
      if (newType == 'Scrum' && selectedDomains.isEmpty) {
        selectedDomains = List.from(AppConstants.domains);
      } else {
        selectedDomains = List.empty();
      }
    });
  }

  Future<void> _uploadMoM() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDomains.isEmpty) {
      _showMessage('Please select at least one domain', 0);
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

      _showMessage(message, 1);
      if (message.toLowerCase().contains("success") && mounted) {
        _resetForm();
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showMessage('An error occurred: $e', 0);
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

  void _showMessage(String message, int status) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: status == 1 ? Colors.green : Colors.red,
    );
  }

  Widget _buildPageTitle() {
    final width = MediaQuery.of(context).size.width;
    return Text(
      'Upload MoM',
      style: AppTextStyles.titleStyle.copyWith(
        fontSize: width * 0.1,
        shadows: const [Shadow(blurRadius: 10, color: AppColors.orangeColor)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageTitle(),
                Divider(color: Color(0xff855D13), thickness: 2),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MoMFormWidgets.buildLabel('MoM TITLE'),
                      SizedBox(height: s.height * 0.005),
                      MoMFormWidgets.buildTextField(
                        titleController,
                        'Enter title...',
                      ),
                      SizedBox(height: s.height * 0.01),

                      MoMFormWidgets.buildLabel('MoM LINK'),
                      SizedBox(height: 4),
                      MoMFormWidgets.buildTextField(
                        linkController,
                        'Enter link...',
                      ),
                      SizedBox(height: s.height * 0.01),

                      MoMFormWidgets.buildLabel(
                        'SELECT DOMAINS (you can select 1 or more)',
                      ),
                      SizedBox(height: s.height * 0.01),

                      // Add the domain selector button here
                      MoMFormWidgets.buildDomainSelectorButton(
                        context: context,
                        selectedDomains: selectedDomains,
                        onDomainsChanged: _onDomainsChanged,
                        buttonText: 'Select Domains',
                      ),

                      SizedBox(height: s.height * 0.01),

                      MoMFormWidgets.buildLabel('MoM TYPE'),
                      SizedBox(height: s.height * 0.005),
                      MoMFormWidgets.buildMeetingTypeDropdown(
                        selectedType: selectedType,
                        onTypeChanged: _onTypeChanged,
                      ),
                      SizedBox(height: s.height * 0.05),
                      Center(
                        child: MoMFormWidgets.buildUploadButton(
                          isLoading: _isLoading,
                          onPressed: _uploadMoM,
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
}
