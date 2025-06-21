import 'package:flutter/material.dart';

class AttendanceSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String placeholder;

  const AttendanceSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(isTablet ? 18 : 14),
        border: Border.all(color: Color(0xFFE5A122).withOpacity(0.3), width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: Colors.white, fontSize: isTablet ? 18 : 16),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: isTablet ? 18 : 16,
            overflow: TextOverflow.ellipsis
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFFE5A122),
            size: isTablet ? 28 : 24,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: isTablet ? 20 : 14,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[400],
                    size: isTablet ? 28 : 24,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
        ),
      ),
    );
  }
}