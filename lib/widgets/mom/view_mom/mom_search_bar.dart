import 'package:flutter/material.dart';
import 'mom_constants.dart';

/// Custom search bar widget for filtering MoM entries
/// Provides a styled text input field with search icon and border
class MoMSearchBar extends StatelessWidget {
  /// Text controller to manage the search input
  final TextEditingController controller;
  
  /// Callback function triggered when search text changes
  final Function(String) onChanged;

  const MoMSearchBar({
    super.key,
    required this.controller, 
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Custom border styling with rounded corners
      decoration: BoxDecoration(
        border: Border.all(
          color: MoMConstants.primaryAccent, 
          width: MoMLayout.searchBorderWidth,
        ),
        borderRadius: BorderRadius.circular(MoMLayout.searchBorderRadius),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: MoMTextStyles.searchInput,
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle: MoMTextStyles.searchHint,
          border: InputBorder.none, // Remove default border
          prefixIcon: Icon(Icons.search, color: MoMConstants.primaryAccent),
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}