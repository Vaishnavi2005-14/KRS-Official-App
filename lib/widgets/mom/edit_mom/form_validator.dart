class FormValidator {
  // Validate required text fields
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // Validate URL format (basic validation)
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }
    
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    
    if (!urlPattern.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }
  
  // Validate title field
  static String? validateTitle(String? value) {
    return validateRequired(value, fieldName: 'Title');
  }
  
  // Validate link field
  static String? validateLink(String? value) {
    // You can use validateUrl if you want stricter validation
    return validateRequired(value, fieldName: 'Link');
  }
  
  // Validate domain selection
  static String? validateDomains(Set<String> selectedDomains) {
    if (selectedDomains.isEmpty) {
      return 'Please select at least one domain';
    }
    return null;
  }
}


class FormDataUtils {
  // Find matching domain from available domains list
  static String findMatchingDomain(String initialDomain, List<String> availableDomains) {
    return availableDomains.firstWhere(
      (domain) => domain.trim().toLowerCase() == initialDomain.trim().toLowerCase(),
      orElse: () => '',
    );
  }
  
  // Find matching meeting type from available types list
  static String findMatchingMeetingType(String initialType, List<String> availableTypes, String defaultType) {
    return availableTypes.firstWhere(
      (type) => type.toLowerCase() == initialType.toLowerCase(),
      orElse: () => defaultType,
    );
  }
  
  // Initialize domains from initial values
  static Set<String> initializeDomains(List<String>? initialDomains, List<String> availableDomains, List<String> defaultDomains) {
    final domainsToProcess = initialDomains ?? defaultDomains;
    final selectedDomains = <String>{};
    
    for (final initialDomain in domainsToProcess) {
      final matchingDomain = findMatchingDomain(initialDomain, availableDomains);
      if (matchingDomain.isNotEmpty) {
        selectedDomains.add(matchingDomain);
      }
    }
    
    return selectedDomains;
  }
  
  // Debug print domain initialization
  static void debugPrintDomainInitialization(
    List<String> initialDomains,
    Set<String> selectedDomains,
    List<String> availableDomains,
  ) {    
  }
}
