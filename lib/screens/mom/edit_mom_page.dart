import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/services/mom_service.dart';
import '../../widgets/mom/edit_mom/constants_file.dart';
import '../../widgets/mom/edit_mom/form_validator.dart';

class EditMoMPage extends StatefulWidget {
  final String momId;
  final String? initialTitle;
  final String? initialLink;
  final String? initialType;
  final List<String>? initialDomains;

  const EditMoMPage({
    super.key,
    required this.momId,
    this.initialTitle,
    this.initialLink,
    this.initialType,
    this.initialDomains,
  });

  @override
  State<EditMoMPage> createState() => _EditMoMPageState();
}

class _EditMoMPageState extends State<EditMoMPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _linkController;

  String _selectedType = AppConstants.defaultMeetingType;
  Set<String> _selectedDomains = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _initializeForm() {
    _initializeControllers();
    _initializeFormData();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(
      text: widget.initialTitle ?? AppConstants.defaultTitle,
    );
    _linkController = TextEditingController(
      text: widget.initialLink ?? AppConstants.defaultLink,
    );
  }

  void _initializeFormData() {
    _initializeMeetingType();
    _initializeDomains();
  }

  void _initializeMeetingType() {
    if (widget.initialType != null) {
      _selectedType = FormDataUtils.findMatchingMeetingType(
        widget.initialType!,
        AppConstants.meetingTypes,
        AppConstants.defaultMeetingType,
      );
    }
  }

  void _initializeDomains() {
    _selectedDomains = FormDataUtils.initializeDomains(
      widget.initialDomains,
      AppConstants.domains,
      AppConstants.defaultDomains,
    );

    FormDataUtils.debugPrintDomainInitialization(
      widget.initialDomains ?? AppConstants.defaultDomains,
      _selectedDomains,
      AppConstants.domains,
    );
  }

  Future<void> _saveMoM() async {
    if (!_validateForm()) return;
    await _performSave();
  }

  bool _validateForm() {
    final domainError = FormValidator.validateDomains(_selectedDomains);
    if (domainError != null) {
      Fluttertoast.showToast(
        msg: domainError,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }

    return _formKey.currentState?.validate() ?? false;
  }

  Future<void> _performSave() async {
    _setLoadingState(true);
    Fluttertoast.showToast(
      msg: "Saving MoM",
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_LONG,
    );

    try {
      final result = await _callSaveAPI();
      _handleSaveSuccess(result);
    } catch (error) {
      _handleSaveError(error);
    } finally {
      _finalizeSave();
    }
  }

  Future<String> _callSaveAPI() async {
    return await MoMService.editMoM(
      id: widget.momId,
      title: _titleController.text.trim(),
      docLink: _linkController.text.trim(),
      domains: _selectedDomains.toList(),
      meetType: _selectedType,
    );
  }

  void _handleSaveSuccess(String result) {
    if (mounted) {
      Fluttertoast.showToast(
        msg: result,
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG,
      );
      Navigator.pop(context, true);
    }
  }

  void _handleSaveError(dynamic error) {
    if (mounted) {
      Fluttertoast.showToast(
        msg: 'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _finalizeSave() {
    if (mounted) {
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool loading) {
    setState(() => _isLoading = loading);
  }

  void _onDomainToggle(String domain) {
    setState(() {
      if (_selectedDomains.contains(domain)) {
        _selectedDomains.remove(domain);
      } else {
        _selectedDomains.add(domain);
      }
    });
  }

  void _onMeetingTypeChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedType = value;
        if (value.toLowerCase() == 'scrum') {
          _selectedDomains = Set<String>.from(AppConstants.domains);
        }
      });
    }
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
                'EDIT MOM',
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
                  Icons.edit,
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
                  _buildSaveButton(screenWidth, screenHeight, isTablet),
                ],
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
        _buildSectionTitle('MOM TITLE', isTablet),
        SizedBox(height: screenHeight * 0.01),
        _buildTextField(_titleController, 'Enter title...', isTablet),
        SizedBox(height: screenHeight * 0.02),

        _buildSectionTitle('MOM LINK', isTablet),
        SizedBox(height: screenHeight * 0.01),
        _buildTextField(_linkController, 'Enter link...', isTablet),
        SizedBox(height: screenHeight * 0.02),

        _buildSectionTitle('DOMAINS', isTablet),
        SizedBox(height: screenHeight * 0.01),
        _buildDomainSelection(screenWidth, screenHeight, isTablet),
        SizedBox(height: screenHeight * 0.02),

        _buildSectionTitle('MEETING TYPE', isTablet),
        SizedBox(height: screenHeight * 0.01),
        _buildMeetingTypeDropdown(isTablet),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isTablet) {
    return Text(
      title,
      style: TextStyle(
        color: Color(0xFFE5A122),
        fontSize: isTablet ? 18 : 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    bool isTablet,
  ) {
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
        fillColor: Color(0xff06132A),
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

  Widget _buildDomainSelection(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
        border: Border.all(color: Colors.grey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select domains (you can select 1 or more):',
            style: TextStyle(color: Colors.white, fontSize: isTablet ? 14 : 12),
          ),
          SizedBox(height: screenHeight * 0.01),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                AppConstants.domains.map((domain) {
                  final isSelected = _selectedDomains.contains(domain);
                  return FilterChip(
                    label: Text(
                      domain,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Color(0xFFE5A122),
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) => _onDomainToggle(domain),
                    backgroundColor: Color(0xff040E1E),
                    selectedColor: Color(0xFFE5A122),
                    side: BorderSide(color: Color(0xFFE5A122), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingTypeDropdown(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
        border: Border.all(color: Colors.grey.withAlpha(128)),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedType,
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
            AppConstants.meetingTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              );
            }).toList(),
        onChanged: _onMeetingTypeChanged,
      ),
    );
  }

  Widget _buildSaveButton(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveMoM,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE5A122),
            padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            ),
          ),
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
                        'Saving...',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                  : Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }
}
