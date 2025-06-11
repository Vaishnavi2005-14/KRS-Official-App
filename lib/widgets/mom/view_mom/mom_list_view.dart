import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/mom_provider.dart';
import 'mom_tile.dart';
import '../../../screens/mom/mom_detail_page.dart';
import 'mom_utils.dart';

/// Widget that displays a scrollable list of MoM (Minutes of Meeting) entries
/// Each entry is rendered as a MoMTile and can be tapped to view details
class MoMListView extends StatefulWidget {
  /// List of MoM data to display
  final List<Map<String, dynamic>> momList;

  const MoMListView({
    super.key,
    required this.momList,
  });

  @override
  State<MoMListView> createState() => _MoMListViewState();
}

class _MoMListViewState extends State<MoMListView> {
  /// Handles navigation to MoM detail page
  /// Returns true if the detail page made changes that require refresh
  Future<void> _navigateToDetail(Map<String, dynamic> mom) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoMDetailPage(
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
    
    // If changes were made in detail page, refresh the MoM list
    if (result == true) {
      await Provider.of<MoMProvider>(context, listen: false).loadMoMs();
      // setState(() {}); // Force rebuild to reflect changes
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
          title: mom['title'] ?? 'Untitled',
          date: mom['date'] ?? 'Unknown date',
          onTap: () => _navigateToDetail(mom),
        );
      },
    );
  }
}