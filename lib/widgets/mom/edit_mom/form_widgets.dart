import 'package:flutter/material.dart';

// ============================================================================
// REUSABLE FORM WIDGETS
// ============================================================================

class FormWidgets {
  // Common input decoration
  static InputDecoration getInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
      filled: true,
      fillColor: Colors.grey[900],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE5A122)),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE5A122)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE5A122), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Section label widget
  static Widget buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFE5A122),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  // Text field widget
  static Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        decoration: getInputDecoration(hint),
        validator: validator ?? (value) => value?.isEmpty == true ? 'Required field' : null,
      ),
    );
  }

  // Title field section
  static Widget buildTitleField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionLabel('MoM TITLE'),
        buildTextField(
          controller: controller,
          hint: 'Enter title...',
        ),
      ],
    );
  }

  // Link field section
  static Widget buildLinkField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionLabel('MoM LINK'),
        buildTextField(
          controller: controller,
          hint: 'Enter link...',
        ),
      ],
    );
  }
}

// ============================================================================
// DOMAIN SELECTION WIDGETS
// ============================================================================

class DomainSelectionWidgets {
  // Build domain selection section
  static Widget buildDomainSelection({
    required List<String> domains,
    required Set<String> selectedDomains,
    required Function(String) onDomainToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormWidgets.buildSectionLabel('DOMAINS'),
        ...List.generate(
          (domains.length / 2).ceil(),
          (index) => _buildDomainRow(
            domains: domains,
            rowIndex: index,
            selectedDomains: selectedDomains,
            onDomainToggle: onDomainToggle,
          ),
        ),
      ],
    );
  }

  // Build domain row (2 domains per row)
  static Widget _buildDomainRow({
    required List<String> domains,
    required int rowIndex,
    required Set<String> selectedDomains,
    required Function(String) onDomainToggle,
  }) {
    final startIndex = rowIndex * 2;
    final endIndex = (startIndex + 2).clamp(0, domains.length);
    final domainsInRow = domains.sublist(startIndex, endIndex);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: domainsInRow.map((domain) => 
          Expanded(
            child: _buildDomainCheckbox(
              domain: domain,
              isSelected: selectedDomains.contains(domain),
              onToggle: () => onDomainToggle(domain),
            ),
          )
        ).toList(),
      ),
    );
  }

  // Build individual domain checkbox
  static Widget _buildDomainCheckbox({
    required String domain,
    required bool isSelected,
    required VoidCallback onToggle,
  }) {
    return InkWell(
      onTap: onToggle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE5A122) : Colors.transparent,
              border: Border.all(color: const Color(0xFFE5A122), width: 2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 12, color: Colors.black)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              domain,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DROPDOWN WIDGETS
// ============================================================================

class DropdownWidgets {
  // Build meeting type dropdown
  static Widget buildMeetingTypeDropdown({
    required String selectedType,
    required List<String> meetingTypes,
    required Map<String, String> typeDisplayNames,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormWidgets.buildSectionLabel('MoM TYPE'),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: DropdownButtonFormField<String>(
            dropdownColor: Colors.grey[900],
            value: selectedType,
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            decoration: FormWidgets.getInputDecoration('Select Meeting Type'),
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFE5A122)),
            items: meetingTypes.map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(
                  typeDisplayNames[type] ?? type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// BUTTON WIDGETS
// ============================================================================

class ButtonWidgets {
  // Build save button
  static Widget buildSaveButton({
    required bool isLoading,
    required VoidCallback onPressed,
    String text = 'Save',
  }) {
    return Center(
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE5A122),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 5,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
      ),
    );
  }
}
