import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/member.dart';

class ApiService {
  static const String baseUrl = "https://krs-app-server.vercel.app";

  // GET /api/attendance
  static Future<List<Member>> fetchMembers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/attendance'));

      print('Response body: ${response.body}');  // Log the response body

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => Member.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load members. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  // POST /mark to submit attendance
  static Future<void> submitAttendance(
    String token,
    List<Map<String, dynamic>> attendanceData,
  ) async {
    try {
      for (var entry in attendanceData) {
        final response = await http.post(
          Uri.parse('$baseUrl/mark'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(entry),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to submit attendance. Status: ${response.statusCode}, Response: ${response.body}');
        }
      }
    } catch (e) {
      throw Exception('Error submitting attendance: $e');
    }
  }
}
