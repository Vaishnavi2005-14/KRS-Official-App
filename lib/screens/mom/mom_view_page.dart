import 'package:flutter/material.dart';
import 'package:krs_app/widgets/mom/edit_mom/constants_file.dart';
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

    if (result == true && mounted) {
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
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xffE5A122),
              surface: Color(0xFF0E2448),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFF0E2448),
            ),
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

  Widget _buildPageTitle() {
    final width = MediaQuery.of(context).size.width;
    return Text(
      'MoM Details',
      style: AppTextStyles.titleStyle.copyWith(
        fontSize: width * 0.1,
        shadows: const [Shadow(blurRadius: 10, color: AppColors.orangeColor)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MoMLayout.horizontalPadding(s.width),
              vertical: MoMLayout.verticalPadding(s.height),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPageTitle(),
                Row(
                  children: [
                    Expanded(
                      child: MoMSearchBar(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    SizedBox(width: s.width * 0.02),
                    GestureDetector(
                      onTap: () => _pickDate(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          size: 34,
                          color: Color(0xffE5A122),
                        ),
                      ),
                    ),
                    if (_selectedDate.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xffE5A122)),
                        tooltip: 'Clear date',
                        onPressed: _clearDate,
                      ),
                  ],
                ),
                SizedBox(height: s.height * 0.02),

                Row(
                  children: [
                    // Meet Type Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        hint: Text("Meeting Type"),

                        value: _selectedType,
                        dropdownColor: const Color(0xFF0E2448),

                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: Color(0xffE5A122),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: Color(0xffE5A122),
                              width: 2,
                            ),
                          ),
                        ),
                        iconEnabledColor: Color(0xffE5A122),
                        isExpanded: true,
                        items:
                            ['All', ...MoMConstants.meetTypes].map((
                              String type,
                            ) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(
                                  type,
                                  style: TextStyle(color: Color(0xffE5A122)),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedType = value);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: s.width * 0.02),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDomain,
                        dropdownColor: const Color(0xFF0E2448),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: Color(0xffE5A122),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: Color(0xffE5A122),
                              width: 2,
                            ),
                          ),
                        ),
                        iconEnabledColor: Color(0xffE5A122),
                        isExpanded: true,
                        items:
                            ['All', ...MoMConstants.domains].map((
                              String domain,
                            ) {
                              return DropdownMenuItem<String>(
                                value: domain,
                                child: Text(
                                  domain,
                                  style: TextStyle(color: Color(0xffE5A122)),
                                ),
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
                SizedBox(height: s.height * 0.02),

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
                          child: Text(
                            "No MoMs available.",
                            style: MoMTextStyles.emptyState,
                          ),
                        );
                      }

                      return MoMListView(momList: filteredList);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton:
            _isAdmin
                ? FloatingActionButton(
                  shape: CircleBorder(
                    side: BorderSide(width: 2, color: Color(0xffE5A122)),
                  ),
                  onPressed: _navigateToUpload,
                  backgroundColor: Colors.transparent,
                  child: LayoutBuilder(
                    builder:
                        (context, constraints) => Icon(
                          Icons.add,
                          color: Color(0xffE5A122),
                          size: constraints.maxHeight * 0.8,
                        ),
                  ),
                )
                : null,
      ),
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
    final s = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF151E2D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerContainer(height: 20, width: double.infinity * 0.7),
          SizedBox(height: s.height * 0.01),
          _buildShimmerContainer(height: 14, width: double.infinity * 0.4),
          SizedBox(height: s.height * 0.02),
          _buildShimmerContainer(height: 14, width: double.infinity),
          SizedBox(height: s.height * 0.01),
          _buildShimmerContainer(height: 14, width: double.infinity * 0.8),
          SizedBox(height: s.height * 0.01),
          _buildShimmerContainer(height: 14, width: double.infinity * 0.6),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double height,
    required double width,
  }) {
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
