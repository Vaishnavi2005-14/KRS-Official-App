import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constants.dart';

class MoMFormWidgets {
  // Label Widget
  static Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      child: Text(
        text,
        style: TextStyle(color: Color(0xffE5A122), fontWeight: FontWeight.bold),
      ),
    );
  }

  // Text Field Widget
  static Widget buildTextField(
    TextEditingController controller,
    String hintText,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          autofocus: false,
          cursorColor: Colors.white,
          controller: controller,
          style: AppTextStyles.inputStyle,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: orangeColor, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color:
                    controller.text.isNotEmpty
                        ? const Color.fromARGB(138, 255, 255, 255)
                        : orangeColor,
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

  // Domain Selection Widget (Original - kept for backward compatibility)
  static Widget buildDomainSelector({
    required List<String> selectedDomains,
    required Function(String, bool) onDomainChanged,
  }) {
    final allDomains = AppConstants.domains;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          allDomains.map((domain) {
            final isSelected = selectedDomains.contains(domain);

            return CheckboxListTile(
              title: Text(domain, style: const TextStyle(color: Colors.white)),
              value: isSelected,
              activeColor: Color(0xFFE5A122),
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

  // Domain Selection Dialog Widget
  static Future<List<String>?> showDomainSelectorDialog({
    required BuildContext context,
    required List<String> initialSelectedDomains,
  }) async {
    return await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return _DomainSelectorDialog(
          initialSelectedDomains: initialSelectedDomains,
        );
      },
    );
  }

  // Domain Selection Button Widget - Shows selected domains and opens dialog
  static Widget buildDomainSelectorButton({
    required BuildContext context,
    required List<String> selectedDomains,
    required Function(List<String>) onDomainsChanged,
    String buttonText = 'Select Domains',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Button to open dialog
        InkWell(
          onTap: () async {
            final result = await showDomainSelectorDialog(
              context: context,
              initialSelectedDomains: selectedDomains,
            );
            if (result != null) {
              onDomainsChanged(result);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFE5A122), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDomains.isEmpty
                      ? buttonText
                      : '${selectedDomains.length} domain(s) selected',
                  style: TextStyle(
                    color: selectedDomains.isEmpty ? Colors.grey : Colors.white,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Color(0xFFE5A122)),
              ],
            ),
          ),
        ),
        // Show selected domains (optional)
        if (selectedDomains.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                selectedDomains.map((domain) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFE5A122).withAlpha(51),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Color(0xFFE5A122), width: 0.5),
                    ),
                    child: Text(
                      domain,
                      style: const TextStyle(
                        color: Color(0xFFE5A122),
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }

  // Meeting Type Dropdown Widget
  static Widget buildMeetingTypeDropdown({
    required String selectedType,
    required Function(String) onTypeChanged,
  }) {
    return DropdownButtonFormField<String>(
      iconEnabledColor: Color(0xffE5A122),
      dropdownColor: Color(0xff151E2D),
      value: selectedType,
      style: AppTextStyles.inputStyle,
      decoration: AppInputDecoration.getInputDecoration('Select Meeting Type'),
      autofocus: false,
      items:
          AppConstants.meetingTypes
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  'Upload',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
      ),
    );
  }
}

// Private Dialog Widget Class
class _DomainSelectorDialog extends StatefulWidget {
  final List<String> initialSelectedDomains;

  const _DomainSelectorDialog({required this.initialSelectedDomains});

  @override
  State<_DomainSelectorDialog> createState() => _DomainSelectorDialogState();
}

class _DomainSelectorDialogState extends State<_DomainSelectorDialog> {
  late List<String> selectedDomains;

  @override
  void initState() {
    super.initState();
    selectedDomains = List.from(widget.initialSelectedDomains);
  }

  void _onDomainChanged(String domain, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (!selectedDomains.contains(domain)) {
          selectedDomains.add(domain);
        }
      } else {
        selectedDomains.remove(domain);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.sizeOf(context);
    return AlertDialog(
      backgroundColor: Color(0xff151E2D),
      title: const Text(
        'Select Domains',
        style: TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${selectedDomains.length} domain(s) selected',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            SizedBox(height: s.height * 0.01),
            Flexible(
              child: SingleChildScrollView(child: _buildDomainSelector()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedDomains);
          },
          child: const Text(
            'Apply',
            style: TextStyle(color: Color(0xFFE5A122)),
          ),
        ),
      ],
    );
  }

  Widget _buildDomainSelector() {
    final allDomains = AppConstants.domains;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          allDomains.map((domain) {
            final isSelected = selectedDomains.contains(domain);

            return CheckboxListTile(
              title: Text(domain, style: const TextStyle(color: Colors.white)),
              value: isSelected,
              activeColor: const Color(0xFFE5A122),
              checkColor: Colors.white,
              onChanged: (bool? value) {
                if (value != null) {
                  _onDomainChanged(domain, value);
                }
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
    );
  }
}
