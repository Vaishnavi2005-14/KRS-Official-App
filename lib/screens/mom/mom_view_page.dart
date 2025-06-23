import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mom_provider.dart';
import 'upload_mom_page.dart';
import '../../widgets/mom/view_mom/mom_constants.dart';
import '../../widgets/mom/view_mom/mom_list_view.dart';
import '../../widgets/mom/view_mom/mom_search_bar.dart';
import 'package:krs_app/services/auth.dart';

class MoMViewPage extends StatefulWidget {
  const MoMViewPage({super.key});

  @override
  State<MoMViewPage> createState() => _MoMViewPageState();
}

class _MoMViewPageState extends State<MoMViewPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _searchQuery = '';
  String _selectedDate = '';
  String _selectedType = 'All';
  String _selectedDomain = 'All';
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoMProvider>(context, listen: false).loadMoMs();
    });
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await AuthService().isAdmin();
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _navigateToUpload() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UploadMoMPage()),
    );

    if (result == true) {
      Provider.of<MoMProvider>(context, listen: false).loadMoMs();
      setState(() {});
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.orangeAccent,
              surface: Color(0xFF0E2448),
            ),
            dialogBackgroundColor: const Color(0xFF0E2448),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked.toIso8601String().split('T')[0];
        _dateController.text = _selectedDate;
      });
    }
  }

  void _clearDate() {
    setState(() {
      _selectedDate = '';
      _dateController.clear();
    });
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.orangeAccent,
              thickness: 2,
              height: 16,
            ),
            const SizedBox(height: 10),

            MoMSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
            Expanded(
  child: Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () => _pickDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dateController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF0E2448),
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.white70),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
              ),
            ),
          ),
        ),
      ),
      if (_selectedDate.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          tooltip: 'Clear date',
          onPressed: _clearDate,
        ),
    ],
  ),
),

                const SizedBox(width: 10),

                // Meet Type Filter
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    dropdownColor: const Color(0xFF0E2448),
                    style: const TextStyle(color: Colors.white),
                    underline: Container(height: 0),
                    iconEnabledColor: Colors.white,
                    isExpanded: true,
                    items: ['All', ...MoMConstants.meetTypes].map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),

                // Domain Filter
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedDomain,
                    dropdownColor: const Color(0xFF0E2448),
                    style: const TextStyle(color: Colors.white),
                    underline: Container(height: 0),
                    iconEnabledColor: Colors.white,
                    isExpanded: true,
                    items: ['All', ...MoMConstants.domains].map((String domain) {
                      return DropdownMenuItem<String>(
                        value: domain,
                        child: Text(domain),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedDomain = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: MoMLayout.searchSpacing(height)),

            Expanded(
              child: Consumer<MoMProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return _buildSkeletonLoader();
                  }

                  final filteredList = provider.filterMoMsAdvanced(
                    titleQuery: _searchQuery,
                    dateQuery: _selectedDate,
                    selectedType: _selectedType,
                    selectedDomain: _selectedDomain,
                  );

                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text("No MoMs available.", style: MoMTextStyles.emptyState),
                    );
                  }

                  return MoMListView(momList: filteredList);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: _navigateToUpload,
              backgroundColor: MoMConstants.primaryAccent,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  AppBar _buildAppBar(double width) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text('MoM DETAILS', style: MoMTextStyles.appBarTitle(width)),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildSkeletonItem(),
        );
      },
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1B3A),
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
          _buildShimmerContainer(height: 20, width: double.infinity * 0.7),
          const SizedBox(height: 8),
          _buildShimmerContainer(height: 14, width: double.infinity * 0.4),
          const SizedBox(height: 12),
          _buildShimmerContainer(height: 14, width: double.infinity),
          const SizedBox(height: 6),
          _buildShimmerContainer(height: 14, width: double.infinity * 0.8),
          const SizedBox(height: 6),
          _buildShimmerContainer(height: 14, width: double.infinity * 0.6),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF0E2448),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: _buildShimmerEffect(),
    );
  }

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
                const Color(0xFF0E2448),
                const Color(0xFF1A3A5C),
                const Color(0xFF0E2448),
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
        if (mounted) setState(() {});
      },
    );
  }
}
