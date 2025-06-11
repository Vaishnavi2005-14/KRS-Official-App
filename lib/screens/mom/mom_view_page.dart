import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mom_provider.dart';
import 'upload_mom_page.dart';
import '../../widgets/mom/view_mom/mom_constants.dart';
import '../../widgets/mom/view_mom/mom_list_view.dart';
import '../../widgets/mom/view_mom/mom_search_bar.dart';

/// Main page for viewing and managing Minutes of Meeting (MoM) entries
/// Displays a searchable list of MoMs with options to add new entries
class MoMViewPage extends StatefulWidget {
  const MoMViewPage({super.key});

  @override
  State<MoMViewPage> createState() => _MoMViewPageState();
}

class _MoMViewPageState extends State<MoMViewPage> {
  /// Controller for the search input field
  final TextEditingController _searchController = TextEditingController();

  /// Current search query string
  String _query = '';

  /// Initialize the page and load MoM data
  @override
  void initState() {
    super.initState();
    // Load MoMs when page is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoMProvider>(context, listen: false).loadMoMs();
    });
  }

  /// Clean up resources when page is destroyed
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Handles navigation to upload page and refreshes list if needed
  Future<void> _navigateToUpload() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UploadMoMPage()),
    );

    // If upload was successful, refresh the MoM list
    if (result == true) {
      Provider.of<MoMProvider>(context, listen: false).loadMoMs();
      setState(() {}); // Force rebuild to show new data
    }
  }

  /// Updates search query when user types in search bar
  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
    });
  }

  /// Builds the main UI structure
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    return Scaffold(
      backgroundColor: MoMConstants.backgroundColor,
      appBar: _buildAppBar(width),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MoMLayout.horizontalPadding(width),
          vertical: MoMLayout.verticalPadding(height),
        ),
        child: Column(
          children: [
            // Search bar for filtering MoMs
            MoMSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: MoMLayout.searchSpacing(height)),

            // Main content area - list of MoMs or empty state
            Expanded(
              child: Consumer<MoMProvider>(
                builder: (context, provider, _) {
                  // Show skeleton loader while loading
                  if (provider.isLoading) {
                    return _buildSkeletonLoader();
                  }

                  final filteredList = provider.filterMoMs(_query);

                  // Show empty state if no MoMs match the search
                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text(
                        "No MoMs available.",
                        style: MoMTextStyles.emptyState,
                      ),
                    );
                  }

                  // Show list of filtered MoMs
                  return MoMListView(momList: filteredList);
                },
              ),
            ),
          ],
        ),
      ),
      // Floating action button to add new MoM
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToUpload,
        backgroundColor: MoMConstants.primaryAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Builds the app bar with responsive title
  AppBar _buildAppBar(double width) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text('MoM DETAILS', style: MoMTextStyles.appBarTitle(width)),
    );
  }

  /// Builds skeleton loader to show while data is loading
  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 6, // Show 6 skeleton items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildSkeletonItem(),
        );
      },
    );
  }

  /// Builds individual skeleton item
  Widget _buildSkeletonItem() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1B3A), // Slightly lighter than primary color
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06142E).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title skeleton
          _buildShimmerContainer(height: 20, width: double.infinity * 0.7),
          const SizedBox(height: 8),

          // Date skeleton
          _buildShimmerContainer(height: 14, width: double.infinity * 0.4),
          const SizedBox(height: 12),

          // Content lines skeleton
          _buildShimmerContainer(height: 14, width: double.infinity),
          const SizedBox(height: 6),
          _buildShimmerContainer(height: 14, width: double.infinity * 0.8),
          const SizedBox(height: 6),
          _buildShimmerContainer(height: 14, width: double.infinity * 0.6),
        ],
      ),
    );
  }

  /// Builds shimmer container for skeleton effect
  Widget _buildShimmerContainer({
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF0E2448), // Muted blue-gray base
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: _buildShimmerEffect(),
    );
  }

  /// Creates shimmer animation effect
  Widget _buildShimmerEffect() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0E2448), // Base muted blue-gray
                const Color(0xFF1A3A5C), // Lighter accent
                const Color(0xFF0E2448), // Back to base
              ],
              stops: [
                (value - 0.3).clamp(0.0, 1.0),
                value,
                (value + 0.3).clamp(0.0, 1.0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        );
      },
      onEnd: () {
        // Restart animation
        if (mounted) {
          setState(() {});
        }
      },
    );
  }
}
