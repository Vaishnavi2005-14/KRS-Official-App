import 'package:flutter/material.dart';
import 'package:krs_app/models/notice.dart';
import 'package:krs_app/screens/notice/edit_dialog.dart';
import 'package:krs_app/services/auth.dart';
import 'package:krs_app/services/notice_service.dart';
import 'package:krs_app/widgets/notice/notice_board_header.dart';
import 'package:krs_app/widgets/notice/notice_card.dart';
import 'package:krs_app/widgets/notice/navigation_row.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({super.key});

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  late Future<bool> _adminFuture;
  late Future<NoticePage> _noticesFuture;

  int _currentPage = 1;
  int _totalPages = 10;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _adminFuture = AuthService().isAdmin();
    _fetchNotices();
  }

  void _fetchNotices() {
    _noticesFuture = NoticeApiService().fetchNotices(
      page: _currentPage,
      limit: _limit,
    );
    setState(() {});
  }

  void _onPrevPressed() {
    if (_currentPage <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are already on the first page.')),
      );
    } else {
      setState(() {
        _currentPage--;
        _fetchNotices();
      });
    }
  }

  void _onNextPressed() {
    if (_currentPage >= _totalPages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are already on the last page.')),
      );
    } else {
      setState(() {
        _currentPage++;
        _fetchNotices();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff10162a),
      appBar: const NoticeBoardHeader(),
      body: FutureBuilder<bool>(
        future: _adminFuture,
        builder: (context, adminSnapshot) {
          final isAdmin = adminSnapshot.data ?? false;
          final isAdminLoading =
              adminSnapshot.connectionState == ConnectionState.waiting;

          return Column(
            children: [
              NavigationRow(
                onPrevPressed: _onPrevPressed,
                onNextPressed: _onNextPressed,
              ),
              Expanded(
                child: FutureBuilder<NoticePage>(
                  future: _noticesFuture,
                  builder: (context, noticeSnapshot) {
                    final isNoticesLoading =
                        noticeSnapshot.connectionState ==
                        ConnectionState.waiting;

                    if (isAdminLoading || isNoticesLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          itemCount: 3,
                          itemBuilder: (context, index) => NoticeCard(
                            day: '00',
                            month: '---',
                            heading: '',
                            body: '',
                            onViewAttachment: null,
                            onEdit: null,
                            onDelete: null,
                            isAdmin: false,
                            attachmentUrl: '',
                          ),
                        ),
                      );
                    }

                    if (noticeSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${noticeSnapshot.error}'),
                      );
                    }

                    final noticePage = noticeSnapshot.data;
                    final notices = noticePage?.notices ?? [];
                    _totalPages = noticePage?.totalPages ?? 1;

                    if (notices.isEmpty) {
                      return const Center(
                        child: Text(
                          'No notices found.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        final notice = notices[index];
                        final day = notice.uploadedAt.day.toString();
                        final month = _monthAbbreviation(
                          notice.uploadedAt.month,
                        );
                        return NoticeCard(
                          day: day,
                          month: month,
                          heading: notice.title,
                          body: notice.description,
                          onViewAttachment: (notice.attachmentLink != null &&
                                  notice.attachmentLink!.isNotEmpty)
                              ? () => _openAttachment(
                                    context,
                                    notice.attachmentLink!,
                                  )
                              : null,
                          onEdit: isAdmin
                              ? () async {
                                  final updatedNotice =
                                      await showDialog<Notice>(
                                    context: context,
                                    builder: (ctx) => EditNoticeDialog(
                                      notice: notice,
                                    ),
                                  );
                                  if (updatedNotice != null) {
                                    setState(() {
                                      _fetchNotices();
                                    });
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Notice updated successfully',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              : null,
                          onDelete: isAdmin
                              ? () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Notice'),
                                      content: const Text(
                                        'Are you sure you want to delete this notice?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    try {
                                      await NoticeApiService().deleteNotice(
                                        notice.id,
                                      );
                                      setState(() {
                                        _fetchNotices();
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Notice deleted successfully',
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  }
                                }
                              : null,
                          isAdmin: isAdmin,
                          attachmentUrl: notice.attachmentLink ?? '',
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Page $_currentPage of $_totalPages',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _monthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _openAttachment(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open attachment')),
      );
    }
  }
}