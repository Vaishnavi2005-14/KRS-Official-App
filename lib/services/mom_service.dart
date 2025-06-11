import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MoMService {
  static const String _baseUrl = 'https://krs-app-server.vercel.app/api/mom';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Map<String, dynamic>>> fetchMoMs() async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found.');

    final url = Uri.parse(_baseUrl);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map<Map<String, dynamic>>((item) {
        return {
          'id': item['_id'] ?? 'Unknown',
          'title': item['title'] ?? 'Untitled',
          'date':
              (item['uploadedAt'] as String?)?.split('T').first ?? 'Unknown',
          'uploadedBy': item['uploadedBy'] ?? 'Unknown',
          'meetingType': item['meetType'] ?? 'Unknown',
          'domains': List<String>.from(item['domains'] ?? []),
          'meetingLink': item['docLink'] ?? 'Unknown',
        };
      }).toList();
    } else {
      throw Exception('Failed to load MoM data');
    }
  }

  static Future<String> uploadMoM({
    required String title,
    required String docLink,
    required List<String> domains,
    required String meetType,
  }) async {
    final token = await _getToken();
    if (token == null) return 'Authentication token not found.';

    final uri = Uri.parse('$_baseUrl/upload');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'docLink': docLink,
        'domains': domains,
        'meetType': meetType,
      }),
    );

    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Upload completed.';
    } catch (_) {
      return response.body;
    }
  }

  static Future<String> deleteMoM(String momId) async {
  final token = await _getToken();
  if (token == null) return 'Authentication token not found.';

  final url = Uri.parse('https://krs-app-server.vercel.app/api/mom/$momId');

  final response = await http.delete(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  try {
    final data = jsonDecode(response.body);
    return data['message'] ?? 'MoM deleted successfully';
  } catch (_) {
    return response.body;
  }
}

  static Future<String> editMoM({
    required String id,
    required String title,
    required String docLink,
    required List<String> domains,
    required String meetType,
  }) async {
    final token = await _getToken();
    if (token == null) return 'Authentication token not found.';

    final uri = Uri.parse('https://krs-app-server.vercel.app/api/mom/edit/$id');

    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'docLink': docLink,
        'domains': domains,
        'meetType': meetType,
      }),
    );

    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'MoM updated successfully.';
    } catch (_) {
      return response.body;
    }
  }
}