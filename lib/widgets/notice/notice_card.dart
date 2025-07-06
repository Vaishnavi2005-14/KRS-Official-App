import 'package:flutter/material.dart';
import 'date_card.dart';
import 'notice_actions.dart';

class NoticeCard extends StatelessWidget {
  final String day;
  final String month;
  final String heading;
  final String body;
  final String attachmentUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isAdmin;

  const NoticeCard({
    super.key,
    required this.day,
    required this.month,
    required this.heading,
    required this.body,
    required this.attachmentUrl,
    this.onEdit,
    this.onDelete,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateCard(day: day, month: month),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              color: const Color(0xff23263b),
              elevation: 3,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      heading,
                      style: const TextStyle(
                        color: Color(0xffE5A122),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      body,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    NoticeActions(
                      attachmentUrl: attachmentUrl,
                      onEdit: isAdmin ? onEdit : null,
                      onDelete: isAdmin ? onDelete : null,
                      showActions: isAdmin,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
