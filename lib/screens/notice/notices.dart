import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:krs_app/models/notice.dart';
import 'package:krs_app/screens/notice/edit_dialog.dart';
import 'package:krs_app/services/auth.dart';
import 'package:krs_app/services/notice_service.dart';
import 'package:krs_app/widgets/notice/notice_board_header.dart';
import 'package:krs_app/widgets/notice/notice_card.dart';
import 'package:krs_app/widgets/notice/navigation_row.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({super.key});

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  late Future<bool> _adminFuture;
  Future<NoticePage>? _noticesFuture;

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 6;

  @override
  void initState() {
    super.initState();
    _adminFuture = AuthService().isAdmin();
    _noticesFuture = NoticeApiService().fetchNotices(
      page: _currentPage,
      limit: _limit,
    );
  }

  void _fetchNotices() {
    setState(() {
      _noticesFuture = NoticeApiService().fetchNotices(
        page: _currentPage,
        limit: _limit,
      );
    });
  }

  void _onPrevPressed() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchNotices();
    }
  }

  void _onNextPressed() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchNotices();
    }
  }

  // --- Custom Delete Dialog ---
  Future<bool?> showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xff10162a),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 44,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Delete Notice?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to delete this entire notice? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.white54,
                          width: 1.2,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06132A),
      appBar: const NoticeBoardHeader(),
      body: FutureBuilder<bool>(
        future: _adminFuture,
        builder: (context, adminSnapshot) {
          final isAdmin = adminSnapshot.data ?? false;
          final isAdminLoading =
              adminSnapshot.connectionState == ConnectionState.waiting;

          return Column(
            children: [
              if (_totalPages > 1)
                NavigationRow(
                  onPrevPressed: _currentPage > 1 ? _onPrevPressed : null,
                  onNextPressed:
                      _currentPage < _totalPages ? _onNextPressed : null,
                  showPrev: _totalPages > 1 && _currentPage > 1,
                  showNext: _totalPages > 1 && _currentPage < _totalPages,
                )
              else
                const SizedBox(height: 20),
              Expanded(
                child: _noticesFuture == null
                    ? const SizedBox.shrink()
                    : FutureBuilder<NoticePage>(
                        future: _noticesFuture,
                        builder: (context, noticeSnapshot) {
                          final isNoticesLoading =
                              noticeSnapshot.connectionState ==
                                  ConnectionState.waiting;

                          if (isAdminLoading || isNoticesLoading) {
                            return Skeletonizer(
                              enabled: true,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                itemCount: 3,
                                itemBuilder: (context, index) => NoticeCard(
                                  day: '00',
                                  month: '---',
                                  heading: '',
                                  body: '',
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
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
                                          Fluttertoast.showToast(
                                            msg:
                                                'Notice updated successfully',
                                            backgroundColor: Colors.green,
                                            toastLength: Toast.LENGTH_LONG,
                                          );
                                        }
                                      }
                                    : null,
                                onDelete: isAdmin
                                    ? () async {
                                        final confirm =
                                            await showDeleteDialog(context);
                                        if (confirm == true) {
                                          try {
                                            await NoticeApiService()
                                                .deleteNotice(notice.id);
                                            setState(() {
                                              _fetchNotices();
                                            });
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Notice deleted successfully",
                                            );
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                              msg: "Error : $e",
                                              backgroundColor: Colors.red,
                                              toastLength: Toast.LENGTH_LONG,
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
              if (_totalPages > 1)
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
}
