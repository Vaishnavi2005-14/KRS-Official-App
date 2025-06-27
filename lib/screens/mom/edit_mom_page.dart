import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/services/mom_service.dart';
import '../../widgets/mom/edit_mom/constants_file.dart';
import '../../widgets/mom/edit_mom/form_validator.dart';
import '../../widgets/mom/edit_mom/form_widgets.dart';

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

    // Debug print for development
    FormDataUtils.debugPrintDomainInitialization(
      widget.initialDomains ?? AppConstants.defaultDomains,
      _selectedDomains,
      AppConstants.domains,
    );
  }

  // ============================================================================
  // BUSINESS LOGIC
  // ============================================================================

  Future<void> _saveMoM() async {
    if (!_validateForm()) return;
    await _performSave();
  }

  bool _validateForm() {
    // Validate domains first
    final domainError = FormValidator.validateDomains(_selectedDomains);
    if (domainError != null) {
      Fluttertoast.showToast(
        msg: domainError,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }

    // Validate form fields
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
        msg: 'Failed to save MoM: ${error.toString()}',
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

  // ============================================================================
  // EVENT HANDLERS
  // ============================================================================

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

  // ============================================================================
  // UI BUILD METHODS
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.defaultPadding,
        vertical: 20,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildPageTitle(),
            Divider(color: Color(0xff855D13), thickness: 2),
            SizedBox(height: AppDimensions.defaultPadding),
            _buildFormFields(),
            SizedBox(height: AppDimensions.extraLargePadding),
            _buildSaveButton(),
            SizedBox(height: AppDimensions.defaultPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    final width = MediaQuery.of(context).size.width;
    return Text(
      'Edit MoM',
      style: AppTextStyles.titleStyle.copyWith(
        fontSize: width * 0.08,
        shadows: const [Shadow(blurRadius: 10, color: AppColors.orangeColor)],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        FormWidgets.buildTitleField(_titleController),
        FormWidgets.buildLinkField(_linkController),
        SizedBox(height: AppDimensions.defaultPadding),
        DomainSelectionWidgets.buildDomainSelection(
          domains: AppConstants.domains,
          selectedDomains: _selectedDomains,
          onDomainToggle: _onDomainToggle,
        ),
        DropdownWidgets.buildMeetingTypeDropdown(
          selectedType: _selectedType,
          meetingTypes: AppConstants.meetingTypes,
          typeDisplayNames: AppConstants.typeDisplayNames,
          onChanged: _onMeetingTypeChanged,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ButtonWidgets.buildSaveButton(
      isLoading: _isLoading,
      onPressed: _saveMoM,
    );
  }
}
