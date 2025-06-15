import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance_record.dart';
import '../providers/attendance_view_provider.dart';
import '../services/api_service.dart';

class AttendanceViewPage extends StatefulWidget {
  final String title;
  final String date;

  const AttendanceViewPage({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  State<AttendanceViewPage> createState() => _AttendanceViewPageState();
}

class _AttendanceViewPageState extends State<AttendanceViewPage> {
  final List<String> domains = [
    'App Development',
    'Web Development',
    'Machine Learning',
    'Embedded',
    'Content',
    'Graphic Designing',
    'Photography',
    'Operations',
  ];

  final List<String> statuses = [
    'Present',
    'Absent',
    'Absent with Reason',
    'Present Online',
  ];

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      final provider = Provider.of<AttendanceViewProvider>(context, listen: false);
      await provider.fetchAttendance(token, widget.date, widget.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06132A),
      appBar: AppBar(
        backgroundColor: const Color(0xff06132A),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Attendance',
          style: TextStyle(
            color: Color(0xffE5A122),
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<AttendanceViewProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)));
          }
          final attendance = provider.attendance;
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Color(0xffE5A122),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                Row(
                  children: [
                    Flexible(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: provider.selectedDomain,
                        hint: const Text('Domain', style: TextStyle(color: Colors.white70)), // <-- HINT ADDED
                        decoration: _dropdownDecoration("Domain"),
                        items: domains
                            .map((d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(
                                    d,
                                    style: const TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) => provider.selectedDomain = val,
                        dropdownColor: const Color(0xff06132A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: provider.selectedStatus,
                        hint: const Text('Status', style: TextStyle(color: Colors.white70)), // <-- HINT ADDED
                        decoration: _dropdownDecoration("Status"),
                        items: statuses
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    s,
                                    style: const TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) => provider.selectedStatus = val,
                        dropdownColor: const Color(0xff06132A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: attendance == null
                      ? const Center(
                          child: Text(
                            'No attendance data available',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : provider.filteredRecords.isEmpty
                          ? const Center(
                              child: Text(
                                'No records match your filters',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                              itemCount: provider.filteredRecords.length,
                              itemBuilder: (context, index) {
                                final record = provider.filteredRecords[index];
                                final isAbsent = record.status == 'Absent';
                                final hasRemarks = record.remarks != null && record.remarks!.trim().isNotEmpty;
                                return Card(
                                  color: const Color(0xff06132A),
                                  surfaceTintColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Color(0xffE5A122), width: 1.5),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: InkWell(
                                    onTap: isAbsent && hasRemarks
                                        ? () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: const Color(0xff06132A),
                                                title: const Text(
                                                  'Remarks',
                                                  style: TextStyle(color: Color(0xffE5A122)),
                                                ),
                                                content: Text(
                                                  record.remarks!,
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text(
                                                      'Close',
                                                      style: TextStyle(color: Color(0xffE5A122)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  record.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  record.domain,
                                                  style: TextStyle(
                                                    color: const Color(0xffE5A122).withOpacity(0.8),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(minWidth: 100, maxWidth: 140),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  record.status,
                                                  style: TextStyle(
                                                    color: record.status == 'Present'
                                                        ? Colors.green
                                                        : record.status == 'Present Online'
                                                            ? const Color(0xffE5A122)
                                                            : Colors.red,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  softWrap: true,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  "Roll No: ${record.rollNo}",
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons.edit, color: Colors.orange),
                                                      onPressed: () {
                                                        _showEditDialog(context, provider, record);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
                if (provider.hasUnsavedChanges)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save Attendance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE5A122),
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final provider = context.read<AttendanceViewProvider>();
                        final attendance = provider.attendance;
                        if (attendance == null) return;

                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token') ?? '';

                        try {
                          for (final record in provider.changedRecords) {
                            await ApiService.updateUserAttendance(
                              token: token,
                              attendanceId: attendance.id,
                              userId: record.userId,
                              status: record.status,
                              remarks: record.remarks,
                            );
                          }
                          provider.markSaved();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Attendance updated successfully!')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error updating attendance: ${e.toString()}')),
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, AttendanceViewProvider provider, AttendanceRecord record) {
    String status = record.status;
    String remarks = record.remarks ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: const Color(0xff06132A),
            title: const Text('Edit Attendance', style: TextStyle(color: Color(0xffE5A122))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: status,
                  hint: const Text('Select Status', style: TextStyle(color: Colors.white70)), // <-- HINT ADDED
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                  items: statuses
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s, style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => status = val!),
                  dropdownColor: const Color(0xff06132A),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: TextEditingController(text: remarks),
                  onChanged: (val) => remarks = val,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel', style: TextStyle(color: Color(0xffE5A122))),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  provider.updateRecordStatusAndReason(record.userId, status, remarks);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _dropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xff06132A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xffE5A122), width: 2.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xffE5A122), width: 2.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xffE5A122), width: 2.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
