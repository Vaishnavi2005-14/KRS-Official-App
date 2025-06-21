import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/providers/attendance_provider.dart';

class DomainFilterChips extends StatelessWidget {
  const DomainFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Consumer<AttendanceProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          itemCount: provider.availableDomains.length,
          itemBuilder: (context, index) {
            final domain = provider.availableDomains[index];
            final isSelected = provider.selectedDomain == domain;

            return Container(
              margin: EdgeInsets.only(
                right: screenWidth * 0.03,
                bottom: isTablet ? 10 : 8,
              ),
              child: FilterChip(
                label: Text(
                  domain,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Color(0xFFE5A122),
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  provider.updateSelectedDomain(domain);
                },
                backgroundColor: const Color(0xff06132A),
                selectedColor: Color(0xFFE5A122),
                side: BorderSide(color: Color(0xFFE5A122), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 24 : 12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 14 : 10,
                  vertical: isTablet ? 10 : 8,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
