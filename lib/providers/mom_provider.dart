import 'package:flutter/material.dart';
import '../services/mom_service.dart';

class MoMProvider with ChangeNotifier {
  List<Map<String, dynamic>> _momList = [];

  List<Map<String, dynamic>> get momList => _momList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadMoMs() async {
    try {
      _isLoading = true;
      notifyListeners();
      _momList = await MoMService.fetchMoMs();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  List<Map<String, dynamic>> filterMoMs(String query) {
    return _momList
        .where(
          (mom) => mom['title']!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
