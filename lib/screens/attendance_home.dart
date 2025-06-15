import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krs_app/screens/attendance_record.dart';
import 'attendance_page.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome({super.key});

  @override
  State<AttendanceHome> createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedDate;

  Future<void> _showAddAttendanceDialog() async {
    _titleController.clear();
    _selectedDate = null;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff06132A),
        title: const Text("New Attendance Session", 
            style: TextStyle(color: Colors.white)),
        content: _buildDialogContent(),
        actions: _buildDialogActions(),
      ),
    );
  }

  Widget _buildDialogContent() {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Session Title",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffE5A122))),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            icon: const Icon(Icons.calendar_today, color: Color(0xffE5A122)),
            label: Text(
              _selectedDate ?? "Select Date",
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () async => await _selectDate(setState),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(void Function(void Function()) setState) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xffE5A122),
            onPrimary: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = DateFormat('dd/MM/yyyy').format(picked));
    }
  }

  List<Widget> _buildDialogActions() {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffE5A122)),
        onPressed: _saveAttendanceSession,
        child: const Text("Save", style: TextStyle(color: Colors.black)),
      ),
    ];
  }

  void _saveAttendanceSession() {
    final title = _titleController.text.trim();
    final date = _selectedDate;
    if (title.isNotEmpty && date != null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AttendancePage(
            title: title,
            date: date,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff040E1E),
      appBar: _buildAppBar(),
      body: _buildCardLayout(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height * 0.12,
      backgroundColor: Colors.transparent,
      title: const Text(
        "ATTENDANCE",
        style: TextStyle(
          color: Color(0xffE5A122),
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildCardLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
              maxWidth: double.infinity,
            ),
            child: _buildActionCard(
              title: "Mark Attendance",
              icon: Icons.edit_calendar,
              onTap: _showAddAttendanceDialog,
            ),
          ),
          const SizedBox(height: 30),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
              maxWidth: double.infinity,
            ),
            child: _buildActionCard(
              title: "View Attendance",
              icon: Icons.list_alt,
              onTap: () => Navigator.push(
  context,
  MaterialPageRoute(builder: (_) =>  AttendanceRecordsPage()),
),

          ),
      )],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xff06132A),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xffE5A122), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xffE5A122), size: 40),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
