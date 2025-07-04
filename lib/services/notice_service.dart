import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krs_app/models/notice.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isValidUrl(String url) {
  final uri = Uri.tryParse(url);
  return uri != null &&
      (uri.isScheme('http') || uri.isScheme('https')) &&
      uri.host.isNotEmpty;
}

class NoticePage {
  final int page;
  final int totalPages;
  final int totalNotices;
  final List<Notice> notices;

  NoticePage({
    required this.page,
    required this.totalPages,
    required this.totalNotices,
    required this.notices,
  });

  factory NoticePage.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 1;
      return 1;
    }

    final noticesRaw = json['notices'];
    final noticesList =
        noticesRaw is List
            ? noticesRaw
            : (noticesRaw is Map ? noticesRaw.values.toList() : <dynamic>[]);

    return NoticePage(
      page: parseInt(json['page']),
      totalPages: parseInt(json['totalPages']),
      totalNotices: parseInt(json['totalNotices']),
      notices: noticesList.map((n) => Notice.fromJson(n)).toList(),
    );
  }
}

class NoticeApiService {
  static const String baseUrl = 'https://krs-app-server.vercel.app';

  Future<NoticePage> fetchNotices({int page = 1, int limit = 10}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/api/notice/view?page=$page&limit=$limit');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return NoticePage.fromJson(jsonData);
    } else if (response.statusCode == 401) {
      throw Exception('Access denied. No token provided.');
    } else {
      throw Exception('Failed to fetch notices: ${response.body}');
    }
  }

  Future<void> deleteNotice(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/api/notice/$id');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final jsonData = jsonDecode(response.body);
      throw Exception(jsonData['message'] ?? 'Failed to delete notice.');
    }
  }

  Future<Notice> editNotice({
    required String id,
    required String title,
    required String description,
    String? attachmentLink,
  }) async {
    if (title.trim().isEmpty || description.trim().isEmpty) {
      throw Exception('Title and description are required.');
    }
    if (description.length > 1000) {
      throw Exception('Description must be 1000 characters or fewer.');
    }
    if (attachmentLink != null && attachmentLink.trim().isNotEmpty) {
      if (!isValidUrl(attachmentLink.trim())) {
        throw Exception('Attachment link must be a valid URL (http/https).');
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/api/notice/edit/$id');
    final body = {
      'title': title.trim(),
      'description': description.trim(),
      if (attachmentLink != null && attachmentLink.trim().isNotEmpty)
        'attachmentLink': attachmentLink.trim(),
    };

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Notice.fromJson(jsonData['notice'] ?? jsonData);
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      final jsonData = jsonDecode(response.body);
      throw Exception(jsonData['message'] ?? 'Failed to edit notice.');
    } else {
      throw Exception('Failed to edit notice: ${response.body}');
    }
  }

  Future<Notice> uploadNotice({
    required String title,
    required String description,
    String? attachmentLink,
  }) async {
    if (title.trim().isEmpty || description.trim().isEmpty) {
      throw Exception('Title and description are required.');
    }
    if (attachmentLink != null && attachmentLink.trim().isNotEmpty) {
      if (!isValidUrl(attachmentLink.trim())) {
        throw Exception('Attachment link must be a valid URL (http/https).');
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/api/notice/upload');
    final body = {
      'title': title.trim(),
      'description': description.trim(),
      if (attachmentLink != null && attachmentLink.trim().isNotEmpty)
        'attachmentLink': attachmentLink.trim(),
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      print('Backend response: $jsonData'); 
      return Notice.fromJson(jsonData['notice']);
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      final jsonData = jsonDecode(response.body);
      throw Exception(jsonData['message'] ?? 'Failed to upload notice.');
    } else {
      throw Exception('Failed to upload notice: ${response.body}');
    }
  }
}
