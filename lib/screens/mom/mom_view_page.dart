import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:krs_app/screens/mom/mom_detail_page.dart';
import 'package:krs_app/services/connectivity.dart';
import 'package:krs_app/widgets/attendance/attendance_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../providers/mom_provider.dart';
import 'upload_mom_page.dart';
import '../../widgets/mom/view_mom/mom_constants.dart';
import 'package:krs_app/services/auth.dart';

class MoMViewPage extends StatefulWidget {
  const MoMViewPage({super.key});

  @override
  State<MoMViewPage> createState() => _MoMViewPageState();
}

class _MoMViewPageState extends State<MoMViewPage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

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
    _checkInitialConnectivity();
    _listenToConnectivityChanges();
    _checkAdminStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoMProvider>(context, listen: false).loadMoMs();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _searchController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _checkInitialConnectivity() async {
    bool connected = await _connectivityService.isConnected();
    setState(() {
      _isConnected = connected;
    });
  }

  void _listenToConnectivityChanges() {
    _connectivitySubscription = _connectivityService.connectivityStream.listen((
      List<ConnectivityResult> results,
    ) {
      bool wasConnected = _isConnected;
      bool isNowConnected = !results.contains(ConnectivityResult.none);

      setState(() {
        _isConnected = isNowConnected;
      });

      if (!wasConnected && isNowConnected) {
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            Provider.of<MoMProvider>(context, listen: false).loadMoMs();
          }
        });
      }
    });
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await AuthService().isAdmin();
    setState(() {
      _isAdmin = isAdmin;
    });
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
              primary: Color(0xFFE5A122),
              surface: Color(0xFF06132A),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFF06132A),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'MOM DETAILS',
                style: TextStyle(
                  color: Color(0xFFE5A122),
                  fontSize: isTablet ? 28 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(isTablet ? 10 : 8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(26),
                  borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                ),
                child: Icon(
                  Icons.description,
                  color: Colors.white,
                  size: isTablet ? 28 : 24,
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xff040E1E),
          elevation: 0,
          toolbarHeight: isTablet ? 70 : 56,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: isTablet ? 28 : 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child:
              _isConnected
                  ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenWidth * 0.01,
                          left: screenWidth * 0.04,
                          right: screenWidth * 0.04,
                          bottom: screenWidth * 0.02,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AttendanceSearchBar(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                placeholder: 'Search MoMs by title',
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            GestureDetector(
                              onTap: () => _pickDate(context),
                              child: Container(
                                padding: EdgeInsets.all(isTablet ? 12 : 10),
                                decoration: BoxDecoration(
                                  color: Color(0xff06132A),
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 10 : 8,
                                  ),
                                  border: Border.all(
                                    color: Color(0xFFE5A122),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color(0xFFE5A122),
                                  size: isTablet ? 28 : 24,
                                ),
                              ),
                            ),
                            if (_selectedDate.isNotEmpty)
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Color(0xFFE5A122),
                                  size: isTablet ? 24 : 20,
                                ),
                                tooltip: 'Clear date',
                                onPressed: _clearDate,
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildFilterDropdown(
                                value: _selectedType,
                                items: ['All', ...MoMConstants.meetTypes],
                                hint: 'Meeting Type',
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedType = value);
                                  }
                                },
                                isTablet: isTablet,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: _buildFilterDropdown(
                                value: _selectedDomain,
                                items: ['All', ...MoMConstants.domains],
                                hint: 'Domain',
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedDomain = value);
                                  }
                                },
                                isTablet: isTablet,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Expanded(
                        child: Consumer<MoMProvider>(
                          builder: (context, provider, _) {
                            return Skeletonizer(
                              enabled: provider.isLoading,
                              child:
                                  provider.isLoading
                                      ? _buildSkeletonList(
                                        screenWidth,
                                        screenHeight,
                                        isTablet,
                                      )
                                      : _buildMoMsList(
                                        context,
                                        provider,
                                        screenWidth,
                                        screenHeight,
                                        isTablet,
                                      ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                  : _buildNoInternetView(screenWidth, screenHeight, isTablet),
        ),
        floatingActionButton:
            _isAdmin && _isConnected
                ? FloatingActionButton(
                  onPressed: _navigateToUpload,
                  backgroundColor: Color(0xFFE5A122),
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: isTablet ? 32 : 28,
                  ),
                )
                : null,
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff06132A),
        borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
        border: Border.all(color: Colors.grey.withAlpha(128), width: 1),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: Color(0xff040E1E),
        style: TextStyle(color: Colors.white, fontSize: isTablet ? 14 : 12),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: isTablet ? 14 : 12,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 16 : 12,
            vertical: isTablet ? 16 : 12,
          ),
        ),
        iconEnabledColor: Color(0xFFE5A122),
        isExpanded: true,
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSkeletonList(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Color(0xff06132A),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: Colors.grey.withAlpha(78), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: isTablet ? 24 : 20,
                color: Colors.grey[300],
              ),
              SizedBox(height: 8),
              Container(
                width: screenWidth * 0.4,
                height: isTablet ? 16 : 14,
                color: Colors.grey[300],
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: isTablet ? 14 : 12,
                color: Colors.grey[300],
              ),
              SizedBox(height: 8),
              Container(
                width: screenWidth * 0.6,
                height: isTablet ? 14 : 12,
                color: Colors.grey[300],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoMsList(
    BuildContext context,
    MoMProvider provider,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    final filteredList = provider.filterMoMsAdvanced(
      titleQuery: _searchQuery,
      dateQuery: _selectedDate,
      selectedType: _selectedType,
      selectedDomain: _selectedDomain,
    );

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: isTablet ? 120 : 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'No MoMs found',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: isTablet ? 20 : 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final mom = filteredList[index];
        final isScrum = mom['meetingType']?.toString().toLowerCase() == 'scrum';

        return Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff06132A), Color(0xff0A1A35)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(
              color: Color(0xFFE5A122).withAlpha(51),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MoMDetailPage(
                          title: mom['title'] ?? 'Unknown',
                          date: mom['date'] ?? '',
                          uploadedBy:
                              mom['uploadedBy'] is Map
                                  ? mom['uploadedBy']['name'] ?? 'Unknown'
                                  : mom['uploadedBy'] ?? 'Unknown',
                          meetingType: mom['meetingType'] ?? 'Unknown',
                          domains: List<String>.from(mom['domains'] ?? []),
                          meetingLink: mom['meetingLink'] ?? '',
                          id: mom['id'] ?? '',
                        ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            mom['title'] ?? 'Unknown',
                            style: TextStyle(
                              color: Color(0xFFE5A122),
                              fontSize: isTablet ? 18 : 15,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 14 : 10,
                            vertical: isTablet ? 8 : 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFE5A122).withAlpha(26),
                                Color(0xFFE5A122).withAlpha(51),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color(0xFFE5A122).withAlpha(128),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            mom['meetingType'] ?? 'Unknown',
                            style: TextStyle(
                              color: Color(0xFFE5A122),
                              fontSize: isTablet ? 12 : 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.008),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey[500],
                          size: isTablet ? 14 : 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          mom['date'] ?? '',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: isTablet ? 13 : 11,
                          ),
                        ),
                        if (mom['date'] != null && mom['date'].isNotEmpty)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              shape: BoxShape.circle,
                            ),
                          ),
                        Icon(
                          Icons.person_outline,
                          color: Colors.grey[500],
                          size: isTablet ? 14 : 12,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${mom['uploadedBy'] is Map ? mom['uploadedBy']['name'] ?? 'Unknown' : mom['uploadedBy'] ?? 'Unknown'}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: isTablet ? 13 : 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    if (!isScrum &&
                        mom['domains'] != null &&
                        (mom['domains'] as List).isNotEmpty) ...[
                      SizedBox(height: screenHeight * 0.015),
                      Container(
                        padding: EdgeInsets.all(isTablet ? 12 : 10),
                        decoration: BoxDecoration(
                          color: Color(0xff040E1E).withAlpha(128),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 10 : 8,
                          ),
                          border: Border.all(
                            color: Colors.grey.withAlpha(51),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isTablet ? 6 : 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFE5A122).withAlpha(26),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.groups_3_rounded,
                                color: Color(0xFFE5A122),
                                size: isTablet ? 16 : 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                (mom['domains'] as List).join(' • '),
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: isTablet ? 12 : 10,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoInternetView(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/no_internet.svg",
          width: screenWidth * 0.5,
          height: screenHeight * 0.3,
        ),
        SizedBox(height: screenHeight * 0.03),
        Text(
          "Not Connected to Internet",
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            color: Color(0xFFE5A122),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          "Please check your connection and try again",
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: Colors.grey[400],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
