import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    if (attachmentUrl == null || attachmentUrl!.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'No Attachment Found !!!',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    final uri = Uri.parse(attachmentUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(
        msg: 'Could not open attachment',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Only take as much space as needed
      children: [
        if (attachmentUrl != null && attachmentUrl!.trim().isNotEmpty)
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0),
              minimumSize: const Size(0, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(
              Icons.attach_file,
              color: Color(0xFFE5A122),
              size: 14,
            ),
            label: const Text(
              'Attachment',
              style: TextStyle(
                color: Color(0xFFE5A122),
                fontSize: 14,
              ),
            ),
            onPressed: () => _handleAttachment(context),
          ),
        if (attachmentUrl != null && attachmentUrl!.trim().isNotEmpty && showActions && (onEdit != null || onDelete != null))
          const SizedBox(width: 4),
        if (showActions && (onEdit != null || onDelete != null)) ...[
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
              onPressed: onEdit,
              tooltip: 'Edit',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: onDelete,
              tooltip: 'Delete',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ],
    );
  }
}
