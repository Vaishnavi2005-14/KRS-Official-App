import 'package:flutter/material.dart';
import 'package:krs_app/widgets/attendance/attendance_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/attendance.dart';
import '../../services/api_service.dart';
import 'attendance_view.dart';

class AttendanceRecordsPage extends StatefulWidget {
  const AttendanceRecordsPage({super.key});

  @override
  State<AttendanceRecordsPage> createState() => _AttendanceRecordsPageState();
}

class _AttendanceRecordsPageState extends State<AttendanceRecordsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Attendance> _allRecords = [];
  List<Attendance> _filteredRecords = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAttendance();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAttendance() async {
    _isLoading = true;
    _error = null;
    if (mounted) notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Authentication required. Please login again.');
      }

      _allRecords = await ApiService.fetchAllAttendance(token);
      _filteredRecords = _allRecords;
      _isLoading = false;
      if (mounted) notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      if (mounted) notifyListeners();
    }
  }

  void _filterRecords(String query) {
    _searchQuery = query;
    _filteredRecords = _allRecords.where((record) {
      final topic = record.topic.toLowerCase();
      final date = record.date.toLowerCase();
      final searchLower = query.toLowerCase();
      return topic.contains(searchLower) || date.contains(searchLower);
    }).toList();
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void notifyListeners() {
    if (mounted) setState(() {});
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
                Icons.history,
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
          Padding(
            padding: EdgeInsets.only(
              top: screenWidth * 0.01,
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              bottom: screenWidth * 0.02,
            ),
            child: AttendanceSearchBar(
              controller: _searchController,
              onChanged: _filterRecords,
              placeholder: 'Search by topic or date',
            ),
          ),
          Expanded(
            child: Skeletonizer(
              enabled: _isLoading,
              child: _isLoading
                  ? _buildSkeletonList(screenWidth, screenHeight, isTablet)
                  : _error != null
                      ? _buildErrorWidget(screenWidth, screenHeight, isTablet)
                      : _filteredRecords.isEmpty
                          ? _buildEmptyWidget(screenWidth, screenHeight, isTablet)
                          : _buildRecordsList(screenWidth, screenHeight, isTablet),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(double screenWidth, double screenHeight, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _error!.toLowerCase().contains('internet') ||
                    _error!.toLowerCase().contains('network') ||
                    _error!.toLowerCase().contains('connection')
                ? Icons.wifi_off
                : Icons.error_outline,
            size: isTablet ? 120 : 80,
            color: Colors.red,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.red,
              fontSize: isTablet ? 20 : 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Text(
              _error!,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: isTablet ? 16 : 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          ElevatedButton(
            onPressed: () {
              _clearError();
              _fetchAttendance();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE5A122),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: isTablet ? 16 : 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
              ),
            ),
            child: Text(
              'Retry',
              style: TextStyle(
                color: Colors.black,
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(double screenWidth, double screenHeight, bool isTablet) {
    return Center(
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
            _searchQuery.isEmpty
                ? 'No attendance records found'
                : 'No records match your search',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: isTablet ? 20 : 16,
            ),
          ),
          if (_allRecords.isEmpty && !_isLoading) ...[
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () => _fetchAttendance(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE5A122),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                ),
              ),
              child: Text(
                'Load Records',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecordsList(double screenWidth, double screenHeight, bool isTablet) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      itemCount: _filteredRecords.length,
      itemBuilder: (context, index) {
        final attendance = _filteredRecords[index];
        return Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.015),
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Color(0xff06132A),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
                  builder: (_) => AttendanceViewPage(
                    title: attendance.topic,
                    date: attendance.date,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.topic,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 20 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.002),
                      Text(
                        attendance.date,
                        style: TextStyle(
                          color: Color(0xFFE5A122).withOpacity(0.8),
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
    );
  }

  Widget _buildSkeletonList(double screenWidth, double screenHeight, bool isTablet) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Color(0xff06132A),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: isTablet ? 60 : 50,
                height: isTablet ? 60 : 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: isTablet ? 20 : 16,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: screenWidth * 0.5,
                      height: isTablet ? 16 : 12,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              Container(
                width: isTablet ? 24 : 20,
                height: isTablet ? 24 : 20,
                color: Colors.grey[300],
              ),
            ],
          ),
        );
      },
    );
  }
}