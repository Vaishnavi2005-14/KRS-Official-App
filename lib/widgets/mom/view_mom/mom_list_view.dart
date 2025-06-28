import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/mom_provider.dart';
import 'mom_tile.dart';
import '../../../screens/mom/mom_detail_page.dart';
import 'mom_utils.dart';

class MoMListView extends StatefulWidget {
  final List<Map<String, dynamic>> momList;

  const MoMListView({super.key, required this.momList});

  @override
  State<MoMListView> createState() => _MoMListViewState();
}

class _MoMListViewState extends State<MoMListView> {
  Future<void> _navigateToDetail(Map<String, dynamic> mom) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MoMDetailPage(
              title: mom['title'] ?? 'Untitled',
              date: mom['date'] ?? 'Unknown date',
              uploadedBy: MoMUtils.extractUploaderName(mom['uploadedBy']),
              meetingType: mom['meetingType'] ?? 'N/A',
              domains: MoMUtils.extractDomains(mom['domains']),
              meetingLink: mom['meetingLink'] ?? 'No link',
              id: mom['id'] ?? '',
            ),
      ),
    );

    if (result == true && mounted) {
      await Provider.of<MoMProvider>(context, listen: false).loadMoMs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.momList.length,
      itemBuilder: (context, index) {
        final reversedIndex = widget.momList.length - 1 - index;
        final mom = widget.momList[reversedIndex];
        return MoMTile(
          type: mom['meetingType'],
          domain: MoMUtils.extractDomains(mom['domains']),
          title: mom['title'] ?? 'Untitled',
          date: mom['date'] ?? 'Unknown date',
          onTap: () => _navigateToDetail(mom),
        );
      },
    );
  }
}
