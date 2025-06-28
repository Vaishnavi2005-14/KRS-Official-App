import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/member.dart';
import '../models/attendance.dart';

class ApiService {
  static const String baseUrl = "https://krs-app-server.vercel.app";

  static Exception _createApiException(http.Response response, String message) {
    final status = response.statusCode;
    final body = response.body.replaceAll('\n', ' ');
    return Exception('$message. Status: $status, Response: $body');
  }

  static Future<List<Member>> fetchMembers(String token, String team) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/attendance?team=$team'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => Member.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load members. Status: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  // static Future<void> submitAttendance(
  //   String token,
  //   List<Map<String, dynamic>> attendanceData,
  // ) async {
  //   try {
  //     // print("Hello" + baseUrl);
  //     // print(attendanceData);
  //     for (var entry in attendanceData) {
  //       final response = await http.post(
  //         Uri.parse('$baseUrl/attendance/mark'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         },
  //         body: json.encode(entry),
  //       );

  //       if (response.statusCode != 200) {
  //         throw Exception(
  //           'Failed to submit attendance. Status: ${response.statusCode}, Response: ${response.body}',
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     throw Exception('Error submitting attendance: $e');
  //   }
  // }

  static Future<List<Attendance>> fetchAllAttendance(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/attendance/all'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Attendance.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Failed to load attendance records. Please try again.');
      }
    } catch (e) {
      final message = e.toString().toLowerCase();

      if (message.contains('timeout') ||
          message.contains('host lookup') ||
          message.contains('network') ||
          message.contains('failed') ||
          message.contains('unreachable')) {
        throw Exception(
          'No internet connection. Please check your network and try again.',
        );
      }

      throw Exception('Error fetching attendance records: $e');
    }
  }

  static Future<void> updateUserAttendance({
    required String token,
    required String attendanceId,
    required String userId,
    required String status,
    String? remarks,
  }) async {
    final uri = Uri.parse('$baseUrl/api/attendance/updateattendancebyid');
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

  static Future<void> deleteUserAttendance({
    required String token,
    required String attendanceId,
    required String userId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/attendance/deleteuserattendance');
    final body = {"attendance_id": attendanceId, "user_id": userId};
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

  static Future<void> updateMeetingAttendance({
    required String token,
    required String attendanceId,
    String? date,
    String? topic,
    String? categoryType,
    String? team,
  }) async {
    final uri = Uri.parse('$baseUrl/api/attendance/updateattendancedetails');
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
      throw _createApiException(
        response,
        'Failed to update meeting attendance',
      );
    }
  }

  static Future<void> deleteAttendanceRecord({
    required String token,
    required String attendanceId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/attendance/deleteattendancerecord');
    final body = {"attendance_id": attendanceId};
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

  static Future<void> submitAttendanceSession(
    String token,
    Map<String, dynamic> attendanceSessionData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/attendance/mark'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(attendanceSessionData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Failed to submit attendance session. Status: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error submitting attendance session: $e');
    }
  }

  static Future<List<Member>> fetchMembersForSelection(
    String token,
    String team,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/attendance?team=$team'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => Member.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load members. Status: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  static Future<List<Attendance>> fetchAttendanceByDateRange({
    required String token,
    String? from,
    String? to,
  }) async {
    String url = '$baseUrl/api/attendance/all';
    if (from != null && to != null) {
      url += '?from=$from&to=$to';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
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

  static Future<List<Map<String, dynamic>>> getUserAttendanceById({
    required String token,
    required String userId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/attendance/getusrattendancebyid?user_id=$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List data = responseData['data'] ?? [];
      return data.cast<Map<String, dynamic>>();
    } else {
      throw _createApiException(response, 'Failed to get user attendance');
    }
  }

  static Future<void> sendBroadcastNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/api/notifications/send-broadcast',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'title': title, 'body': body}),
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to send notification');
      }
    } catch (e) {
      throw Exception('Error sending notification: $e');
    }
  }
}
