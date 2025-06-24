import 'package:flutter/material.dart';
import 'package:krs_app/widgets/mom/upload_mom/app_constants.dart';

class MoMTile extends StatelessWidget {
  final String title, date, type;
  final List domain;
  final VoidCallback onTap;

  const MoMTile({
    super.key,
    required this.title,
    required this.date,
    required this.onTap,
    required this.domain,
    required this.type,
  });

  String dom() {
    if (type == "leads-only") {
      return "Leads Meet";
    } else if (domain.length == 1) {
      return domain[0];
    } else if (type == 'inter-domain') {
      return "Inter Domain";
    } else {
      return "Scrum";
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: s.height * 0.008),
        padding: EdgeInsets.symmetric(
          vertical: s.height * 0.015,
          horizontal: s.width * 0.04,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5A122)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: s.width * 0.045,
                    color: const Color(0xFFE5A122),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: s.height * 0.02),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: orangeColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(dom(), style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Text(
              date,
              style: TextStyle(
                color: Colors.white70,
                fontSize: s.width * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
