import 'package:flutter/material.dart';
import 'package:krs_app/models/notice.dart';
import 'package:krs_app/services/notice_service.dart';

class EditNoticeDialog extends StatefulWidget {
  final Notice notice;
  const EditNoticeDialog({super.key, required this.notice});

  @override
  State<EditNoticeDialog> createState() => _EditNoticeDialogState();
}

class _EditNoticeDialogState extends State<EditNoticeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _attachmentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.notice.title);
    _descController = TextEditingController(text: widget.notice.description);
    _attachmentController = TextEditingController(text: widget.notice.attachmentLink ?? '');
    print('[DEBUG] EditNoticeDialog initialized with notice ID: ${widget.notice.id}');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _attachmentController.dispose();
    print('[DEBUG] EditNoticeDialog disposed');
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      print('[DEBUG] Form validation failed');
      return;
    }
    setState(() => _isLoading = true);
    print('[DEBUG] Submitting edit for notice ID: ${widget.notice.id}');

    try {
      final updatedNotice = await NoticeApiService().editNotice(
        id: widget.notice.id,
        title: _titleController.text,
        description: _descController.text,
        attachmentLink: _attachmentController.text.isNotEmpty
            ? _attachmentController.text
            : null,
      );
      print('[DEBUG] Notice updated successfully: ${updatedNotice.id}');
      if (context.mounted) {
        Navigator.of(context).pop(updatedNotice);
        return;
      }
    } catch (e) {
      print('[ERROR] Failed to edit notice: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[800],
            content: Text('Error: $e', style: const TextStyle(color: Colors.white)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        print('[DEBUG] EditNoticeDialog loading state set to false');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xff06132A);
    const goldColor = Color(0xffE5A122);
    const whiteColor = Colors.white;

    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Edit Notice', style: TextStyle(color: goldColor, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitleField(),
              const SizedBox(height: 12),
              _buildDescriptionField(),
              const SizedBox(height: 12),
              _buildAttachmentField(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(color: Color(0xffE5A122)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffE5A122)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffE5A122), width: 2),
        ),
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          print('[DEBUG] Title validation failed');
          return 'Title required';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descController,
      style: const TextStyle(color: Colors.white),
      maxLines: 100,
      maxLength: 1000,
      decoration: const InputDecoration(
        labelText: 'Description (max 1000 chars)',
        labelStyle: TextStyle(color: Color(0xffE5A122)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffE5A122)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffE5A122), width: 2),
        ),
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          print('[DEBUG] Description validation failed: empty');
          return 'Description required';
        }
        if (val.length > 1000) {
          print('[DEBUG] Description validation failed: too long');
          return 'Max 1000 characters';
        }
        return null;
      },
    );
  }

  Widget _buildAttachmentField() {
    return TextFormField(
      controller: _attachmentController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.url,
      decoration: const InputDecoration(
        labelText: 'Attachment Link (optional)',
        labelStyle: TextStyle(color: Color(0xffE5A122)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffE5A122)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffE5A122), width: 2),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffE5A122),
        foregroundColor: const Color(0xff06132A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: _isLoading ? null : _submit,
      child: _isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xff06132A),
              ),
            )
          : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
