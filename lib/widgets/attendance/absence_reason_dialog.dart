import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AbsenceReasonDialog extends StatefulWidget {
  final Function(String) onSave;
  final VoidCallback onCancel;

  const AbsenceReasonDialog({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<AbsenceReasonDialog> createState() => _AbsenceReasonDialogState();
}

class _AbsenceReasonDialogState extends State<AbsenceReasonDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Dialog(
      backgroundColor: Color(0xff06132A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
      ),
      child: Container(
        width: isTablet ? screenWidth * 0.6 : screenWidth * 0.9,
        constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Absence Reason',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Container(
                  constraints: BoxConstraints(maxHeight: screenHeight * 78),
                  decoration: BoxDecoration(
                    color: Color(0xff040E1E),
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    border: Border.all(
                      color: Color(0xFFE5A122).withAlpha(78),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _reasonController,
                      maxLines: null,
                      minLines: isTablet ? 4 : 3,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 18 : 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter reason here...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: isTablet ? 18 : 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onCancel();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 16 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 10 : 8,
                            ),
                            side: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final reason = _reasonController.text.trim();
                          if (reason.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please enter a reason",
                              backgroundColor: Colors.red,
                              toastLength: Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          Navigator.pop(context);
                          widget.onSave(reason);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE5A122),
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 16 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 10 : 8,
                            ),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isTablet ? 18 : 16,
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
}
