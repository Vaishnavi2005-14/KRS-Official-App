/*import 'package:flutter/material.dart';
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
}*/
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

  /// Basic title filter (still usable if needed)
  List<Map<String, dynamic>> filterMoMs(String query) {
    return _momList
        .where(
          (mom) => mom['title']!
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Advanced filtering for multiple fields
  List<Map<String, dynamic>> filterMoMsAdvanced({
    required String titleQuery,
    required String dateQuery,
    required String selectedType,
    required String selectedDomain,
  }) {
    return _momList.where((mom) {
      final titleMatch = mom['title']
          ?.toString()
          .toLowerCase()
          .contains(titleQuery.toLowerCase()) ??
          false;

      final dateMatch = dateQuery.isEmpty ||
          mom['date']
              ?.toString()
              .toLowerCase()
              .contains(dateQuery.toLowerCase()) ==
              true;

      final typeMatch = selectedType == 'All' ||
          mom['meetingType']?.toString().toLowerCase() == selectedType.toLowerCase();

      final domainMatch = selectedDomain == 'All' ||
          (mom['domains'] is List &&
              (mom['domains'] as List)
                  .map((e) => e.toString().toLowerCase())
                  .contains(selectedDomain.toLowerCase()));

      return titleMatch && dateMatch && typeMatch && domainMatch;
    }).toList();
  }
}

