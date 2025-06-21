import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeActions extends StatelessWidget {
  final String? attachmentUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const NoticeActions({
    super.key,
    this.attachmentUrl,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  Future<void> _handleAttachment(BuildContext context) async {
    if (attachmentUrl == null || attachmentUrl!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No Attachment Found !!!')));
      return;
    }
    final uri = Uri.parse(attachmentUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open attachment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (attachmentUrl != null && attachmentUrl!.trim().isNotEmpty)
          TextButton.icon(
            icon: const Icon(Icons.attach_file, color: Colors.white, size: 18),
            label: const Text(
              'Attachment',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _handleAttachment(context),
          ),
        // This Spacer pushes the actions to the right
        const Spacer(),
        if (showActions) ...[
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: onEdit,
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
        ],
      ],
    );
  }
}
