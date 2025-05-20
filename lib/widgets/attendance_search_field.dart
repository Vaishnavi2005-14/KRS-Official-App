import 'package:flutter/material.dart';

class AttendanceSearchField extends StatelessWidget {
  final TextEditingController controller;
  final bool hasSearched;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const AttendanceSearchField({
    super.key,
    required this.controller,
    required this.hasSearched,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search members...',
        hintStyle: const TextStyle(color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            hasSearched ? Icons.clear : Icons.search,
            color: Colors.orange,
          ),
          onPressed: hasSearched ? onClear : onSearch,
        ),
        filled: true,
        fillColor: const Color(0xFF040E1E),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.amberAccent,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.amberAccent,
            width: 2,
          ),
        ),
      ),
      onSubmitted: (_) => onSearch(),
    );
  }
}