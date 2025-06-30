import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../providers/user_attendance_provider.dart';

class UserAttendanceDetailPage extends StatefulWidget {
  final String userId;
  final String userName;
  final String userDomain;
  final String userImage;
  final String userRoll;

  const UserAttendanceDetailPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.userDomain,
    required this.userImage,
    required this.userRoll,
  });

  @override
  State<UserAttendanceDetailPage> createState() =>
      _UserAttendanceDetailPageState();
}

class _UserAttendanceDetailPageState extends State<UserAttendanceDetailPage> {
  UserAttendanceProvider? _provider;

  Future<void> _fetchUserAttendance(UserAttendanceProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty) {
      await provider.fetchUserAttendance(
        token: token,
        userId: widget.userId,
        userName: widget.userName,
        userDomain: widget.userDomain,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return ChangeNotifierProvider(
      create: (_) => UserAttendanceProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'DETAILS',
                style: TextStyle(
                  color: Color(0xFFE5A122),
                  fontSize: isTablet ? 28 : screenWidth * 0.065,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(isTablet ? 10 : 8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(26),
                  borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                ),
                child: Icon(
                  Icons.person_pin,
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
        body: Consumer<UserAttendanceProvider>(
          builder: (context, provider, _) {
            if (_provider != provider) {
              _provider = provider;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _fetchUserAttendance(provider);
              });
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                    top: screenWidth * 0.02,
                    bottom: screenWidth * 0.04,
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Color(0xff06132A),
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(
                      color: Color(0xFFE5A122).withAlpha(78),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: isTablet ? 80 : 70,
                        height: isTablet ? 80 : 70,
                        decoration: BoxDecoration(
                          color: Color(0xFFE5A122).withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: isTablet ? 40 : 35,
                          backgroundColor: Color(0xFFE5A122),
                          backgroundImage:
                              widget.userImage.isNotEmpty
                                  ? NetworkImage(widget.userImage)
                                  : null,
                          child:
                              widget.userImage.isEmpty
                                  ? Text(
                                    widget.userName.isNotEmpty
                                        ? widget.userName[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: isTablet ? 28 : 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.userDomain,
                              style: TextStyle(
                                color: Color(0xFFE5A122).withAlpha(204),
                                fontSize: isTablet ? 18 : 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Roll No: ${widget.userRoll}",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Skeletonizer(
                    enabled: provider.isLoading,
                    child:
                        provider.isLoading
                            ? _buildSkeletonList(
                              screenWidth,
                              screenHeight,
                              isTablet,
                            )
                            : provider.error != null
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: isTablet ? 120 : 80,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04,
                                    ),
                                    child: Text(
                                      'Error: ${provider.error}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: isTablet ? 20 : 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  ElevatedButton(
                                    onPressed: () {
                                      provider.clearError();
                                      _fetchUserAttendance(provider);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFE5A122),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.06,
                                        vertical: isTablet ? 16 : 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          isTablet ? 12 : 8,
                                        ),
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
                            )
                            : provider.attendanceRecords.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    size: isTablet ? 120 : 80,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Text(
                                    'No attendance records found',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: isTablet ? 20 : 16,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'This user has no attendance history',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  ElevatedButton(
                                    onPressed:
                                        () => _fetchUserAttendance(provider),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFE5A122),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.06,
                                        vertical: isTablet ? 16 : 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          isTablet ? 12 : 8,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Load Attendance',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: isTablet ? 16 : 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                              ),
                              itemCount: provider.attendanceRecords.length,
                              itemBuilder: (context, index) {
                                final record =
                                    provider.attendanceRecords[index];
                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: screenHeight * 0.02,
                                  ),
                                  padding: EdgeInsets.all(screenWidth * 0.04),
                                  decoration: BoxDecoration(
                                    color: Color(0xff06132A),
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 16 : 12,
                                    ),
                                    border: Border.all(
                                      color: Colors.grey.withAlpha(78),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                              isTablet ? 12 : 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(
                                                0xFFE5A122,
                                              ).withAlpha(51),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    isTablet ? 10 : 8,
                                                  ),
                                            ),
                                            child: Icon(
                                              Icons.event,
                                              color: Color(0xFFE5A122),
                                              size: isTablet ? 24 : 20,
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.04),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  record['topic'] ?? 'No Topic',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        isTablet ? 20 : 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Text(
                                                      record['date'] ??
                                                          'No Date',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFFE5A122,
                                                        ).withAlpha(204),
                                                        fontSize:
                                                            isTablet ? 16 : 14,
                                                      ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withAlpha(51),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        record['categoryType'] ??
                                                            'General',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[300],
                                                          fontSize:
                                                              isTablet
                                                                  ? 12
                                                                  : 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.04,
                                          vertical: isTablet ? 12 : 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: provider
                                              .getStatusColor(
                                                record['status'] ?? 'Unknown',
                                              )
                                              .withAlpha(51),
                                          borderRadius: BorderRadius.circular(
                                            isTablet ? 10 : 8,
                                          ),
                                          border: Border.all(
                                            color: provider.getStatusColor(
                                              record['status'] ?? 'Unknown',
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          record['status'] ?? 'Unknown',
                                          style: TextStyle(
                                            color: provider.getStatusColor(
                                              record['status'] ?? 'Unknown',
                                            ),
                                            fontSize: isTablet ? 16 : 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonList(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
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
            border: Border.all(color: Colors.grey.withAlpha(78), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: isTablet ? 48 : 40,
                    height: isTablet ? 48 : 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
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
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: double.infinity,
                height: isTablet ? 48 : 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
