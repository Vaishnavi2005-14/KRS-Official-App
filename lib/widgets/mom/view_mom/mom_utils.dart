/// Utility functions for MoM (Minutes of Meeting) feature
/// Contains helper methods for data extraction and formatting
class MoMUtils {
  /// Extracts uploader name from dynamic data structure
  /// Handles both Map and direct string formats
  /// 
  /// [uploadedBy] can be either:
  /// - Map<String, dynamic> with 'name' key
  /// - Direct string value
  /// - null value
  /// 
  /// Returns formatted name string or 'Unknown' as fallback
  static String extractUploaderName(dynamic uploadedBy) {
    // Handle Map format (e.g., {'name': 'John Doe', 'id': '123'})
    if (uploadedBy is Map<String, dynamic>) {
      return uploadedBy['name'] ?? 'Unknown';
    }
    
    // Handle direct string or other formats
    return uploadedBy?.toString() ?? 'Unknown';
  }
  
  /// Extracts and formats domain list from dynamic data
  /// Converts various data types to List<String>
  /// 
  /// [domains] can be:
  /// - List<dynamic> containing domain strings
  /// - null value
  /// 
  /// Returns formatted List<String> or empty list as fallback
  static List<String> extractDomains(dynamic domains) {
    if (domains is List<dynamic>) {
      return domains
          .map((domain) => domain.toString())
          .toList();
    }
    
    return []; // Return empty list if domains is null or invalid format
  }
  
  /// Validates if MoM data has required fields
  /// Used for data integrity checks before processing
  /// 
  /// [momData] - Map containing MoM information
  /// Returns true if all required fields are present
  static bool isValidMoMData(Map<String, dynamic> momData) {
    final requiredFields = ['title', 'date', 'id'];
    
    for (String field in requiredFields) {
      if (!momData.containsKey(field) || momData[field] == null) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Formats date string for consistent display
  /// Can be extended to handle different date formats
  /// 
  /// [dateString] - Raw date string from data source
  /// Returns formatted date string
  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Unknown date';
    }
    
    // Add custom date formatting logic here if needed
    // For now, return as-is
    return dateString;
  }
}