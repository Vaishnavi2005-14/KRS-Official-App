import 'dart:convert';
import 'package:http/http.dart' as http;

class MemberApiService {
  static const String baseUrl = "https://krs-app-server.vercel.app";

  static Exception _createApiException(http.Response response, String message) {
    final status = response.statusCode;
    final body = response.body.replaceAll('\n', ' ');
    return Exception('$message. Status: $status, Response: $body');
  }

  static Future<List<Map<String, dynamic>>> getPendingMembers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/members/pending'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List data = responseData['data'] ?? [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw _createApiException(response, 'Failed to load pending members');
      }
    } catch (e) {
      throw Exception('Error fetching pending members: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllMembers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/members/all'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List data = responseData['data'] ?? [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw _createApiException(response, 'Failed to load members');
      }
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  static Future<void> updateMemberStatus(
    String token,
    List<Map<String, String>> updates,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/members/update-status'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(updates),
      );

      if (response.statusCode != 200 && response.statusCode != 207) {
        throw _createApiException(response, 'Failed to update member status');
      }
    } catch (e) {
      throw Exception('Error updating member status: $e');
    }
  }

  static Future<void> updateMemberDesignation(
    String token,
    List<Map<String, String>> updates,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/members/update-designation'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(updates),
      );

      if (response.statusCode != 200 && response.statusCode != 207) {
        throw _createApiException(response, 'Failed to update member designation');
      }
    } catch (e) {
      throw Exception('Error updating member designation: $e');
    }
  }

  static Future<void> deletePendingMember(String token, String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/members/$userId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw _createApiException(response, 'Failed to delete member');
      }
    } catch (e) {
      throw Exception('Error deleting member: $e');
    }
  }
}