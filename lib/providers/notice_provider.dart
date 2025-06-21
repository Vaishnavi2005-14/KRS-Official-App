import 'package:flutter/material.dart';
import 'package:krs_app/models/notice.dart';
import 'package:krs_app/services/notice_service.dart';

class NoticeProvider with ChangeNotifier {
  final NoticeApiService _apiService = NoticeApiService();

  List<Notice> _notices = [];
  bool _isLoading = false;
  String? _error;

  List<Notice> get notices => _notices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNotices({int page = 1, int limit = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final noticePage = await _apiService.fetchNotices(page: page, limit: limit);
      _notices = noticePage.notices;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteNotice(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteNotice(id);
      _notices.removeWhere((notice) => notice.id == id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> editNotice({
    required String id,
    required String title,
    required String description,
    String? attachmentLink,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedNotice = await _apiService.editNotice(
        id: id,
        title: title,
        description: description,
        attachmentLink: attachmentLink,
      );
      final index = _notices.indexWhere((notice) => notice.id == id);
      if (index != -1) {
        _notices[index] = updatedNotice;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> uploadNotice({
    required String title,
    required String description,
    String? attachmentLink,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newNotice = await _apiService.uploadNotice(
        title: title,
        description: description,
        attachmentLink: attachmentLink,
      );
      _notices.insert(0, newNotice); // Add new notice at the beginning
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
