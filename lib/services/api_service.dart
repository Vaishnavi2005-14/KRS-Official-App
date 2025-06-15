import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/member.dart';
import '../models/attendance.dart';

class ApiService {
  static const String baseUrl = "krs-app-server.vercel.app";

  // Helper for error handling
  static Exception _createApiException(http.Response response, String message) {
    final status = response.statusCode;
    final body = response.body.replaceAll('\n', ' ');
    return Exception('$message. Status: $status, Response: $body');
  }

  /// Fetch all members for a team (default: General)
  static Future<List<Member>> fetchMembers(String token, {String team = 'General'}) async {
    final uri = Uri.https(baseUrl, '/api/attendance', {'team': team});
    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Member.fromJson(e)).toList();
    } else {
      throw _createApiException(response, 'Failed to load members');
    }
  }

  /// Fetch attendance for a specific meeting (by date and topic)
  /// Fetch all attendance records
static Future<List<Attendance>> fetchAllAttendance(String token) async {
  final uri = Uri.https(baseUrl, '/api/attendance/all');
  final response = await http.get(
    uri,
    headers: {
      "Authorization": "Bearer $token",
    },
  );
  
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((json) => Attendance.fromJson(json)).toList();
  } else {
    throw _createApiException(response, 'Failed to load attendance records');
  }
}


  /// Submit attendance for a meeting
  static Future<void> submitAttendance(
    String token,
    Attendance attendanceData,
  ) async {
    final uri = Uri.https(baseUrl, '/api/attendance/mark');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(attendanceData.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else if (response.statusCode == 409) {
      throw Exception('Duplicate meeting (same date and topic)');
    } else if (response.statusCode == 400) {
      throw Exception('Validation error: ${response.body}');
    } else {
      throw _createApiException(response, 'Failed to submit attendance');
    }
  }

  /// Update a user's attendance status in a meeting
  static Future<void> updateUserAttendance({
    required String token,
    required String attendanceId,
    required String userId,
    required String status,
    String? remarks,
  }) async {
    final uri = Uri.https(baseUrl, '/api/attendance/updateattendancebyid');
    final body = {
      "attendance_id": attendanceId,
      "user_id": userId,
      "status": status,
      if (remarks != null) "remarks": remarks,
    };
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode != 200) {
      throw _createApiException(response, 'Failed to update user attendance');
    }
  }

  /// Delete a user's attendance from a meeting
  static Future<void> deleteUserAttendance({
    required String token,
    required String attendanceId,
    required String userId,
  }) async {
    final uri = Uri.https(baseUrl, '/api/attendance/deleteuserattendance');
    final body = {
      "attendance_id": attendanceId,
      "user_id": userId,
    };
    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode != 200) {
      throw _createApiException(response, 'Failed to delete user attendance');
    }
  }

  /// Update meeting details (date, topic, etc.)
  static Future<void> updateMeetingAttendance({
    required String token,
    required String attendanceId,
    String? date,
    String? topic,
    String? categoryType,
    String? team,
  }) async {
    final uri = Uri.https(baseUrl, '/api/attendance/updateattendancedetails');
    final body = {
      "attendance_id": attendanceId,
      if (date != null) "date": date,
      if (topic != null) "topic": topic,
      if (categoryType != null) "categoryType": categoryType,
      if (team != null) "team": team,
    };
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode != 200) {
      throw _createApiException(response, 'Failed to update meeting attendance');
    }
  }

  /// Delete an entire attendance record (meeting)
  static Future<void> deleteAttendanceRecord({
    required String token,
    required String attendanceId,
  }) async {
    final uri = Uri.https(baseUrl, '/api/attendance/deleteattendancerecord');
    final body = {
      "attendance_id": attendanceId,
    };
    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode != 200) {
      throw _createApiException(response, 'Failed to delete attendance record');
    }
  }

  
}
