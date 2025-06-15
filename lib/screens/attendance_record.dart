import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance.dart';
import '../services/api_service.dart';
import 'attendance_view.dart';

class AttendanceRecordsPage extends StatefulWidget {
  const AttendanceRecordsPage({super.key});

  @override
  State<AttendanceRecordsPage> createState() => _AttendanceRecordsPageState();
}

class _AttendanceRecordsPageState extends State<AttendanceRecordsPage> {
  late Future<List<Attendance>> _attendanceFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Attendance> _allRecords = [];
  List<Attendance> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _attendanceFuture = _loadAttendance().then((records) {
      _allRecords = records;
      _filteredRecords = _allRecords;
      return records;
    });
  }

  Future<List<Attendance>> _loadAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) throw Exception('No token found');
    return await ApiService.fetchAllAttendance(token);
  }

  void _filterRecords(String query) {
    setState(() {
      _filteredRecords =
          _allRecords.where((record) {
            final topic = record.topic.toLowerCase();
            final date = record.date.toLowerCase();
            final searchLower = query.toLowerCase();
            return topic.contains(searchLower) || date.contains(searchLower);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff040E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xff040E1E),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Records',
          style: TextStyle(
            color: Color(0xffE5A122),
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Attendance>>(
        future: _attendanceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterRecords,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by topic or date...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xffE5A122),
                    ),
                    filled: true,
                    fillColor: const Color(0xff06132A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color(0xffE5A122),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color(0xffE5A122),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child:
                    _filteredRecords.isEmpty
                        ? const Center(
                          child: Text(
                            'No matching records found',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredRecords.length,
                          itemBuilder: (context, index) {
                            final attendance = _filteredRecords[index];
                            return Card(
                              color: const Color(0xff06132A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(
                                  color: Color(0xffE5A122),
                                  width: 1,
                                ),
                              ),
                              margin: const EdgeInsets.only(bottom: 18),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                                title: Text(
                                  attendance.topic,
                                  style: const TextStyle(
                                    color: Color(0xffE5A122),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  attendance.date,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xffE5A122),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => AttendanceViewPage(
                                            title: attendance.topic,
                                            date: attendance.date,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
