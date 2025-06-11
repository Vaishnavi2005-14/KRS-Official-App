import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome({super.key});

  @override
  State<AttendanceHome> createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  final List<Map<String, String>> attendanceList = [];

  String? selectedDate;
  final TextEditingController titleController = TextEditingController();

  Future<void> _showAddAttendanceDialog() async {
    titleController.clear();
    selectedDate = null;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff06132A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Add Attendance",
            style: TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (context, setInnerState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter title",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffE5A122)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffE5A122)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: const Color(0xffE5A122),
                                onPrimary: Colors.black,
                                surface: const Color(0xff06132A),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setInnerState(() {
                          selectedDate = DateFormat(
                            'dd/MM/yyyy',
                          ).format(picked);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xffE5A122),
                    ),
                    label: Text(
                      selectedDate ?? "Pick a date",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && selectedDate != null) {
                  setState(() {
                    attendanceList.add({
                      "title": titleController.text,
                      "date": selectedDate!,
                    });
                  });
                  Navigator.pop(context); // Close dialog first
                  Navigator.pushNamed(
                    context,
                    '/attendance',
                  ); // Navigate to attendance page
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE5A122),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff040E1E),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(s.height * 0.12),
        child: SafeArea(
          child: Center(
            child: Text(
              "ATTENDANCE",
              style: TextStyle(
                color: const Color(0xffE5A122),
                fontSize: s.width * 0.1,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE5A122)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Color(0xffE5A122)),
                ],
              ),
            ),

            // Attendance list or empty state
            Expanded(
              child:
                  attendanceList.isEmpty
                      ? const Center(
                        child: Text(
                          "No Attendance yet !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xffE5A122),
                            fontSize: 18,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: attendanceList.length,
                        itemBuilder: (context, index) {
                          final item = attendanceList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xffE5A122),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    color: Color(0xffE5A122),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  item['date']!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),

      // Mark new attendance button
      floatingActionButton: SizedBox(
        width: s.width * 0.8,
        height: 50,
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xffE5A122),
          onPressed: _showAddAttendanceDialog,
          label: const Text(
            "Mark new Attendance",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
