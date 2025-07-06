import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/widgets/mom/edit_mom/constants_file.dart';
import '../../services/mom_service.dart';

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
      } else if (newType != 'Scrum') {
        selectedDomains = [];
      }
    });
  }

  Future<void> _uploadMoM() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDomains.isEmpty) {
      _showMessage('Please select at least one domain', false);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final message = await MoMService.uploadMoM(
        title: titleController.text.trim(),
        docLink: linkController.text.trim(),
        domains: selectedDomains.map((d) => d.trim()).toList(),
        meetType: selectedType.replaceAll(' ', '-'),
      );

      _showMessage(message, true);
      if (message.toLowerCase().contains("success") && mounted) {
        _resetForm();
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showMessage('Something went wrong. Please try again.', false);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _resetForm() {
    setState(() {
      titleController.clear();
      linkController.clear();
      selectedDomains.clear();
      selectedType = 'Scrum';
      if (selectedType == 'Scrum') {
        selectedDomains = List.from(AppConstants.domains);
      }
    });
  }

  void _showMessage(String message, bool isSuccess) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void _showDomainSelectionDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    List<String> tempSelectedDomains = List.from(selectedDomains);

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => Dialog(
                  backgroundColor: Color(0xff06132A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                  ),
                  child: Container(
                    width: isTablet ? screenWidth * 0.6 : screenWidth * 0.9,
                    constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
                    padding: EdgeInsets.all(screenWidth * 0.06),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff06132A), Color(0xff0A1A35)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                      border: Border.all(color: Color(0xFFE5A122), width: 1),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isTablet ? 12 : 10),
                              decoration: BoxDecoration(
                                color: Color(0xFFE5A122).withAlpha(51),
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 10 : 8,
                                ),
                              ),
                              child: Icon(
                                Icons.category,
                                color: Color(0xFFE5A122),
                                size: isTablet ? 24 : 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Select Domains',
                                style: TextStyle(
                                  color: Color(0xFFE5A122),
                                  fontSize: isTablet ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xff040E1E),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.withAlpha(128),
                            ),
                          ),
                          child: Text(
                            '${tempSelectedDomains.length} domain(s) selected',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: isTablet ? 14 : 12,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children:
                                  AppConstants.domains.map((domain) {
                                    final isSelected = tempSelectedDomains
                                        .contains(domain);
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Color(
                                                  0xFFE5A122,
                                                ).withAlpha(26)
                                                : Color(0xff040E1E),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Color(0xFFE5A122)
                                                  : Colors.grey.withAlpha(128),
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: CheckboxListTile(
                                        title: Text(
                                          domain,
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? Color(0xFFE5A122)
                                                    : Colors.white,
                                            fontSize: isTablet ? 16 : 14,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                        value: isSelected,
                                        activeColor: Color(0xFFE5A122),
                                        checkColor: Colors.black,
                                        onChanged: (bool? value) {
                                          setDialogState(() {
                                            if (value == true) {
                                              tempSelectedDomains.add(domain);
                                            } else {
                                              tempSelectedDomains.remove(
                                                domain,
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
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
                                onPressed: () {
                                  _onDomainsChanged(tempSelectedDomains);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE5A122),
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
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.black,
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
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'UPLOAD MOM',
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
                  Icons.upload,
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
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff040E1E), Color(0xff06132A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          _buildFormFields(screenWidth, screenHeight, isTablet),
                        ],
                      ),
                    ),
                    _buildUploadButton(screenWidth, screenHeight, isTablet),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormSection(
          title: 'MOM TITLE',
          icon: Icons.title,
          child: _buildTextField(
            controller: titleController,
            hint: 'Enter title...',
            isTablet: isTablet,
          ),
          screenHeight: screenHeight,
          isTablet: isTablet,
        ),

        _buildFormSection(
          title: 'MOM LINK',
          icon: Icons.link,
          child: _buildTextField(
            controller: linkController,
            hint: 'Enter link...',
            isTablet: isTablet,
          ),
          screenHeight: screenHeight,
          isTablet: isTablet,
        ),

        _buildFormSection(
          title: 'SELECT DOMAINS',
          subtitle: 'You can select 1 or more',
          icon: Icons.groups_3_rounded,
          child: _buildDomainSelector(screenWidth, screenHeight, isTablet),
          screenHeight: screenHeight,
          isTablet: isTablet,
        ),

        _buildFormSection(
          title: 'MOM TYPE',
          icon: Icons.meeting_room,
          child: _buildMeetingTypeDropdown(isTablet),
          screenHeight: screenHeight,
          isTablet: isTablet,
        ),

        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  Widget _buildFormSection({
    required String title,
    String? subtitle,
    required IconData icon,
    required Widget child,
    required double screenHeight,
    required bool isTablet,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.025),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff06132A), Color(0xff0A1A35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: Colors.grey.withAlpha(128), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 10 : 8),
                decoration: BoxDecoration(
                  color: Color(0xFFE5A122).withAlpha(51),
                  borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                ),
                child: Icon(
                  icon,
                  color: Color(0xFFE5A122),
                  size: isTablet ? 20 : 18,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFFE5A122),
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: isTablet ? 12 : 10,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isTablet,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white, fontSize: isTablet ? 16 : 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: isTablet ? 16 : 14,
        ),
        filled: true,
        fillColor: Color(0xff040E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          borderSide: BorderSide(color: Colors.grey.withAlpha(128)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          borderSide: BorderSide(color: Colors.grey.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          borderSide: BorderSide(color: Color(0xFFE5A122), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: isTablet ? 16 : 12,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildDomainSelector(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return GestureDetector(
      onTap: _showDomainSelectionDialog,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: Color(0xff040E1E),
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          border: Border.all(
            color:
                selectedDomains.isNotEmpty
                    ? Color(0xFFE5A122)
                    : Colors.grey.withAlpha(128),
            width: selectedDomains.isNotEmpty ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedDomains.isEmpty
                        ? 'Tap to select domains'
                        : '${selectedDomains.length} domain(s) selected',
                    style: TextStyle(
                      color:
                          selectedDomains.isEmpty
                              ? Colors.grey[400]
                              : Color(0xFFE5A122),
                      fontSize: isTablet ? 16 : 14,
                      fontWeight:
                          selectedDomains.isNotEmpty
                              ? FontWeight.w600
                              : FontWeight.normal,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFFE5A122),
                  size: isTablet ? 24 : 20,
                ),
              ],
            ),
            if (selectedDomains.isNotEmpty) ...[
              SizedBox(height: screenHeight * 0.01),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children:
                    selectedDomains.map((domain) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 10 : 8,
                          vertical: isTablet ? 6 : 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFE5A122).withAlpha(51),
                              Color(0xFFE5A122).withAlpha(26),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 8,
                          ),
                          border: Border.all(
                            color: Color(0xFFE5A122),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              domain,
                              style: TextStyle(
                                color: Color(0xFFE5A122),
                                fontSize: isTablet ? 12 : 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.check_circle,
                              color: Color(0xFFE5A122),
                              size: isTablet ? 14 : 12,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingTypeDropdown(bool isTablet) {
    if (!AppConstants.meetingTypes.contains(selectedType)) {
      selectedType = AppConstants.meetingTypes.first;
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xff040E1E),
        borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
        border: Border.all(color: Colors.grey.withAlpha(128)),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        dropdownColor: Color(0xff040E1E),
        style: TextStyle(color: Colors.white, fontSize: isTablet ? 16 : 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 16 : 12,
            vertical: isTablet ? 16 : 12,
          ),
        ),
        iconEnabledColor: Color(0xFFE5A122),
        items:
            AppConstants.meetingTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Text(
                      type,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        onChanged: (String? value) {
          if (value != null) {
            _onTypeChanged(value);
          }
        },
      ),
    );
  }

  Widget _buildUploadButton(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE5A122), Color(0xFFD4941F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE5A122).withAlpha(77),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            onTap: _isLoading ? null : _uploadMoM,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 14),
              child:
                  _isLoading
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: isTablet ? 24 : 20,
                            width: isTablet ? 24 : 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Uploading...',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload,
                            color: Colors.black,
                            size: isTablet ? 24 : 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Upload MoM',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
