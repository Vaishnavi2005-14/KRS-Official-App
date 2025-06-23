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
  

static Widget buildTextField(TextEditingController controller, String hintText) {
  return StatefulBuilder(
    builder: (context, setState) {
      return TextFormField(
        controller: controller,
        style: AppTextStyles.inputStyle,
        onChanged: (_) => setState(() {}), 
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[900], 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: orangeColor,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: controller.text.isNotEmpty ? const Color.fromARGB(138, 255, 255, 255) : orangeColor,
              width: 1.5,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      );
    },
  );
}

  // Domain Selection Widget
  static Widget buildDomainSelector({
  required List<String> selectedDomains,
  required Function(String, bool) onDomainChanged,
}) {
  final allDomains = AppConstants.domains; 

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: allDomains.map((domain) {
      final isSelected = selectedDomains.contains(domain);

      return CheckboxListTile(
        title: Text(
          domain,
          style: const TextStyle(color: Colors.white), 
        ),
        value: isSelected,
        activeColor:Color(0xFFE5A122),
        checkColor: Colors.white,
        onChanged: (bool? value) {
          if (value != null) {
            onDomainChanged(domain, value);
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
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
 /* static Widget buildTitle(double width) {
  return Center(
    child: Text(
      'Upload new MoM',
      style: AppTextStyles.titleStyle.copyWith(fontSize: width * 0.08),
    ),
  );
}*/
}