class MoMUtils {
  static String extractUploaderName(dynamic uploadedBy) {
    if (uploadedBy is Map<String, dynamic>) {
      return uploadedBy['name'] ?? 'Unknown';
    }

    return uploadedBy?.toString() ?? 'Unknown';
  }

  static List<String> extractDomains(dynamic domains) {
    if (domains is List<dynamic>) {
      return domains.map((domain) => domain.toString()).toList();
    }

    return [];
  }

  static bool isValidMoMData(Map<String, dynamic> momData) {
    final requiredFields = ['title', 'date', 'id'];

    for (String field in requiredFields) {
      if (!momData.containsKey(field) || momData[field] == null) {
        return false;
      }
    }

    return true;
  }

  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Unknown date';
    }

    return dateString;
  }
}
