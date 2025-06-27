import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/screens/attendance/attendance_marking.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/providers/attendance_provider.dart';

class AttendanceSetupDialog extends StatefulWidget {
  const AttendanceSetupDialog({super.key});

  @override
  State<AttendanceSetupDialog> createState() => _AttendanceSetupDialogState();
}

class _AttendanceSetupDialogState extends State<AttendanceSetupDialog> {
  final _topicController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _categoryType = 'General';
  String _team = 'General';
  bool _isLoading = false;

  @override
  void dispose() {
    _topicController.dispose();
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
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Setup Attendance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                _buildTextField(
                  controller: _topicController,
                  label: 'Topic/Session Name',
                  hint: 'Enter the topic or session name',
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildCategoryDropdown(screenWidth, isTablet),
                SizedBox(height: screenHeight * 0.02),
                if (_categoryType == 'Domain')
                  _buildTeamDropdown(screenWidth, isTablet),
                if (_categoryType == 'Domain')
                  SizedBox(height: screenHeight * 0.02),
                _buildDatePicker(screenWidth, isTablet),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
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
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
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
                        child:
                            _isLoading
                                ? SizedBox(
                                  height: isTablet ? 24 : 20,
                                  width: isTablet ? 24 : 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  'Submit',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
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
              borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
              borderSide: BorderSide(color: Color(0xFFE5A122)),
            ),
            contentPadding: EdgeInsets.all(isTablet ? 16 : 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(double screenWidth, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Type',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: Color(0xff040E1E),
            borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
            border: Border.all(color: Colors.grey[600]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _categoryType,
              dropdownColor: Color(0xff040E1E),
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 16 : 14,
              ),
              items:
                  ['General', 'Domain'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _categoryType = newValue!;
                  if (_categoryType == 'General') {
                    _team = 'General';
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamDropdown(double screenWidth, bool isTablet) {
    final teams = ['Development', 'Design', 'Marketing', 'Management'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: Color(0xff040E1E),
            borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
            border: Border.all(color: Colors.grey[600]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: teams.contains(_team) ? _team : teams.first,
              dropdownColor: Color(0xff040E1E),
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 16 : 14,
              ),
              items:
                  teams.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _team = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(double screenWidth, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 12,
              vertical: isTablet ? 18 : 16,
            ),
            decoration: BoxDecoration(
              color: Color(0xff040E1E),
              borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
              border: Border.all(color: Colors.grey[600]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey[400],
                  size: isTablet ? 24 : 20,
                ),
                SizedBox(width: 12),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFFE5A122),
              onPrimary: Colors.black,
              surface: Color(0xff06132A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSubmit() async {
    if (_topicController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a topic/session name',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final attendanceProvider = Provider.of<AttendanceProvider>(
          context,
          listen: false,
        );

        attendanceProvider.setAttendanceSession(
          topic: _topicController.text.trim(),
          date: _selectedDate,
          categoryType: _categoryType,
          team: _team,
        );

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AttendanceMarkingPage()),
        );
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error setting up attendance: $e',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
}
