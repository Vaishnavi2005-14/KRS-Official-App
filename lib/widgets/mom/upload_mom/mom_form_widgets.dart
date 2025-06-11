import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constants.dart';

class MoMFormWidgets {
  // Label Widget
  static Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      child: Text(text, style: AppTextStyles.labelStyle),
    );
  }

  // Text Field Widget
  static Widget buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      style: AppTextStyles.inputStyle,
      decoration: AppInputDecoration.getInputDecoration(hint),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Required field' : null,
    );
  }

  // Domain Selection Widget
  static Widget buildDomainSelector({
    required List<String> selectedDomains,
    required Function(String, bool) onDomainChanged,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: AppConstants.domains.map((domain) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: selectedDomains.contains(domain),
              activeColor: orangeColor,
              onChanged: (val) => onDomainChanged(domain, val ?? false),
            ),
            Text(domain, style: AppTextStyles.domainStyle),
          ],
        );
      }).toList(),
    );
  }

  // Meeting Type Dropdown Widget
  static Widget buildMeetingTypeDropdown({
    required String selectedType,
    required Function(String) onTypeChanged,
  }) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.grey[900],
      value: selectedType,
      style: AppTextStyles.inputStyle,
      decoration: AppInputDecoration.getInputDecoration('Select Meeting Type'),
      items: AppConstants.meetingTypes
          .map(
            (type) => DropdownMenuItem<String>(
              value: type,
              child: Text(type, style: GoogleFonts.poppins()),
            ),
          )
          .toList(),
      onChanged: (val) => onTypeChanged(val!),
    );
  }

  // Upload Button Widget
  static Widget buildUploadButton({
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: orangeColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : Text('Upload', style: AppTextStyles.buttonStyle),
      ),
    );
  }

  // Title Widget
  static Widget buildTitle(double width) {
    return Text(
      'Upload new MoM',
      style: AppTextStyles.titleStyle.copyWith(fontSize: width * 0.08),
    );
  }
}