import 'package:flutter/material.dart';
import 'package:krs_app/widgets/attendance/attendance_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/providers/member_management_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChangeMemberStatusPage extends StatefulWidget {
  const ChangeMemberStatusPage({super.key});

  @override
  State<ChangeMemberStatusPage> createState() => _ChangeMemberStatusPageState();
}

class _ChangeMemberStatusPageState extends State<ChangeMemberStatusPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MemberManagementProvider>(
        context,
        listen: false,
      ).loadAllMembers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'CHANGE STATUS',
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
                Icons.toggle_on,
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
      body: Consumer<MemberManagementProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: screenWidth * 0.01,
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04,
                  bottom: screenWidth * 0.02,
                ),
                child: AttendanceSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    provider.updateSearchQuery(value);
                  },
                  placeholder: 'Search members by name or email',
                ),
              ),
              SizedBox(
                height: isTablet ? 80 : 60,
                child: Skeletonizer(
                  enabled: provider.isLoading,
                  child: _buildStatusFilterChips(
                    provider,
                    screenWidth,
                    isTablet,
                  ),
                ),
              ),
              Expanded(
                child: Skeletonizer(
                  enabled: provider.isLoading,
                  child:
                      provider.isLoading
                          ? _buildSkeletonList(
                            screenWidth,
                            screenHeight,
                            isTablet,
                          )
                          : _buildMembersList(
                            context,
                            provider,
                            screenWidth,
                            screenHeight,
                            isTablet,
                          ),
                ),
              ),
              if (provider.hasChanges)
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          provider.isSaving
                              ? null
                              : () => _handleSubmit(context, provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE5A122),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 18 : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                        ),
                      ),
                      child:
                          provider.isSaving
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: isTablet ? 24 : 20,
                                    width: isTablet ? 24 : 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Updating...',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: isTablet ? 20 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                              : Text(
                                'Update Status',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: isTablet ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusFilterChips(
    MemberManagementProvider provider,
    double screenWidth,
    bool isTablet,
  ) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      itemCount: provider.availableStatuses.length,
      itemBuilder: (context, index) {
        final status = provider.availableStatuses[index];
        final isSelected = provider.selectedFilter == status;

        return Container(
          margin: EdgeInsets.only(
            right: screenWidth * 0.03,
            bottom: isTablet ? 10 : 8,
          ),
          child: FilterChip(
            label: Text(
              status,
              style: TextStyle(
                color: isSelected ? Colors.black : Color(0xFFE5A122),
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              provider.updateFilter(status);
            },
            backgroundColor: const Color(0xff06132A),
            selectedColor: Color(0xFFE5A122),
            side: BorderSide(color: Color(0xFFE5A122), width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isTablet ? 24 : 12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 14 : 10,
              vertical: isTablet ? 10 : 8,
            ),
          ),
        );
      },
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
          child: Row(
            children: [
              Container(
                width: isTablet ? 60 : 50,
                height: isTablet ? 60 : 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: isTablet ? 20 : 16,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: screenWidth * 0.6,
                      height: isTablet ? 16 : 12,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: screenWidth * 0.4,
                      height: isTablet ? 14 : 10,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              Container(
                width: isTablet ? 100 : 80,
                height: isTablet ? 35 : 30,
                color: Colors.grey[300],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMembersList(
    BuildContext context,
    MemberManagementProvider provider,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isTablet ? 120 : 80,
              color: Colors.red,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Something went wrong',
              style: TextStyle(color: Colors.red, fontSize: isTablet ? 20 : 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                provider.loadAllMembers();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE5A122),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (provider.filteredMembers.isEmpty) {
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
              'No members found',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: isTablet ? 20 : 16,
              ),
            ),
          ],
        ),
      );
    }

    final statuses = ['active', 'inactive'];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      itemCount: provider.filteredMembers.length,
      itemBuilder: (context, index) {
        final member = provider.filteredMembers[index];
        final memberId = member['_id'];
        final currentStatus = member['status'] ?? 'active';
        final updatedStatus = provider.memberUpdates[memberId] ?? currentStatus;
        final hasChanged = provider.memberUpdates.containsKey(memberId);

        return Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Color(0xff06132A),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(
              color:
                  hasChanged ? Color(0xFFE5A122) : Colors.grey.withAlpha(78),
              width: hasChanged ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: isTablet ? 60 : 50,
                    height: isTablet ? 60 : 50,
                    decoration: BoxDecoration(
                      color: Color(0xFFE5A122).withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: isTablet ? 30 : 25,
                      backgroundColor: Color(0xFFE5A122),
                      backgroundImage:
                          (member['image'] != null &&
                                  member['image'].toString().isNotEmpty)
                              ? NetworkImage(member['image'])
                              : null,
                      child:
                          (member['image'] == null ||
                                  member['image'].toString().isEmpty)
                              ? Text(
                                member['name'].toString().isNotEmpty
                                    ? member['name'].toString()[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: isTablet ? 22 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : null,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['name'] ?? 'Unknown',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 20 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          member['email'] ?? '',
                          style: TextStyle(
                            color: Color(0xFFE5A122).withAlpha(204),
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              member['designation'] ?? 'Member',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: isTablet ? 14 : 12,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  currentStatus,
                                ).withAlpha(51),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(currentStatus),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                currentStatus.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(currentStatus),
                                  fontSize: isTablet ? 12 : 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.015),
              Row(
                children: [
                  Text(
                    'Change to:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Container(
                      height: isTablet ? 40 : 35,
                      decoration: BoxDecoration(
                        color: Color(0xff040E1E),
                        borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                        border: Border.all(
                          color:
                              hasChanged
                                  ? Color(0xFFE5A122)
                                  : Colors.grey.withAlpha(128),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value:
                              statuses.contains(updatedStatus)
                                  ? updatedStatus
                                  : statuses.first, // Safety check
                          isExpanded: true,
                          dropdownColor: Color(0xff040E1E),
                          iconEnabledColor: Color(0xFFE5A122),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 14 : 12,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          items:
                              statuses.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(status),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        status.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isTablet ? 14 : 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                          onChanged: (newStatus) {
                            if (newStatus != null &&
                                newStatus != currentStatus) {
                              provider.updateMemberField(memberId, newStatus);
                            } else if (newStatus == currentStatus &&
                                provider.memberUpdates.containsKey(memberId)) {
                              provider.memberUpdates.remove(memberId);
                              provider.notifyListeners();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _handleSubmit(
    BuildContext context,
    MemberManagementProvider provider,
  ) async {
    final success = await provider.submitStatusUpdates();

    _showResultModal(
      context,
      success,
      successMessage: 'Member status updated successfully!',
      errorMessage: provider.error ?? 'Failed to update member status',
    );
  }

  void _showResultModal(
    BuildContext context,
    bool success, {
    required String successMessage,
    required String errorMessage,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Color(0xff06132A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
            ),
            child: Container(
              width: isTablet ? screenWidth * 128 : screenWidth * 204,
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color:
                          success
                              ? Colors.green.withAlpha(51)
                              : Colors.red.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      success ? Icons.check : Icons.error,
                      color: success ? Colors.green : Colors.red,
                      size: isTablet ? 60 : 48,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    success ? 'Success!' : 'Failed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    success ? successMessage : errorMessage,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 18 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (success) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE5A122),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 10 : 8,
                          ),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
