import 'package:flutter/material.dart';
import 'package:krs_app/widgets/attendance/attendance_search_bar.dart';
import '../../models/attendance.dart';
import 'attendance_view.dart';

class FilteredAttendanceRecordsPage extends StatefulWidget {
  final List<Attendance> attendanceRecords;
  final DateTime fromDate;
  final DateTime toDate;

  const FilteredAttendanceRecordsPage({
    super.key,
    required this.attendanceRecords,
    required this.fromDate,
    required this.toDate,
  });

  @override
  State<FilteredAttendanceRecordsPage> createState() =>
      _FilteredAttendanceRecordsPageState();
}

class _FilteredAttendanceRecordsPageState
    extends State<FilteredAttendanceRecordsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Attendance> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _filteredRecords = widget.attendanceRecords;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecords(String query) {
    setState(() {
      _filteredRecords =
          widget.attendanceRecords.where((record) {
            final topic = record.topic.toLowerCase();
            final date = record.date.toLowerCase();
            final searchLower = query.toLowerCase();
            return topic.contains(searchLower) || date.contains(searchLower);
          }).toList();
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'RECORDS',
              style: TextStyle(
                color: Color(0xFFE5A122),
                fontSize: isTablet ? 28 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(isTablet ? 10 : 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
              ),
              child: Icon(
                Icons.filter_list,
                color: Colors.white,
                size: isTablet ? 28 : 24,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff040E1E),
        elevation: 0,
        toolbarHeight: isTablet ? 70 : 56,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: isTablet ? 28 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              top: screenWidth * 0.02,
              bottom: screenWidth * 0.02,
            ),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Color(0xff06132A),
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              border: Border.all(
                color: Color(0xFFE5A122).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range,
                  color: Color(0xFFE5A122),
                  size: isTablet ? 28 : 24,
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Text(
                    '${_formatDate(widget.fromDate)} - ${_formatDate(widget.toDate)}',
                    style: TextStyle(
                      color: Color(0xFFE5A122),
                      fontSize: isTablet ? 18 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFE5A122).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.attendanceRecords.length} records',
                    style: TextStyle(
                      color: Color(0xFFE5A122),
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: AttendanceSearchBar(
              controller: _searchController,
              onChanged: _filterRecords,
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          Expanded(
            child:
                _filteredRecords.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: isTablet ? 120 : 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            _searchController.text.isEmpty
                                ? 'No records found for this date range'
                                : 'No records match your search',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: isTablet ? 20 : 16,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                      ),
                      itemCount: _filteredRecords.length,
                      itemBuilder: (context, index) {
                        final attendance = _filteredRecords[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: Color(0xff06132A),
                            borderRadius: BorderRadius.circular(
                              isTablet ? 16 : 12,
                            ),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: InkWell(
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
                            borderRadius: BorderRadius.circular(
                              isTablet ? 16 : 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: isTablet ? 60 : 50,
                                  height: isTablet ? 60 : 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE5A122).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.event_note,
                                    color: Color(0xFFE5A122),
                                    size: isTablet ? 32 : 28,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        attendance.topic,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isTablet ? 20 : 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        attendance.date,
                                        style: TextStyle(
                                          color: Color(
                                            0xFFE5A122,
                                          ).withOpacity(0.8),
                                          fontSize: isTablet ? 16 : 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFFE5A122),
                                  size: isTablet ? 24 : 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
