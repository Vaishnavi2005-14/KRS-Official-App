import 'package:flutter/material.dart';
import 'package:krs_app/widgets/attendance/attendance_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/providers/member_management_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ApprovePendingMembersPage extends StatefulWidget {
  const ApprovePendingMembersPage({super.key});

  @override
  State<ApprovePendingMembersPage> createState() =>
      _ApprovePendingMembersPageState();
}

class _ApprovePendingMembersPageState extends State<ApprovePendingMembersPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MemberManagementProvider>(
        context,
        listen: false,
      ).loadPendingMembers();
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
              'APPROVALS',
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
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
              ),
              child: Icon(
                Icons.pending_actions,
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
                  placeholder: 'Search pending members',
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
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
                                    'Submitting...',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: isTablet ? 20 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                              : Text(
                                'Submit Approvals',
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
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
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
                width: isTablet ? 60 : 50,
                height: isTablet ? 40 : 30,
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
                provider.loadPendingMembers();
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
              Icons.inbox_outlined,
              size: isTablet ? 120 : 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'No pending members found',
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
      itemCount: provider.filteredMembers.length,
      itemBuilder: (context, index) {
        final member = provider.filteredMembers[index];
        final memberId = member['_id'];
        final isApproved = provider.selectedMembers.contains(memberId);

        return Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Color(0xff06132A),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(
              color:
                  isApproved ? Color(0xFFE5A122) : Colors.grey.withOpacity(0.3),
              width: isApproved ? 2 : 1,
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
                      color: Color(0xFFE5A122).withOpacity(0.2),
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
                        SizedBox(height: 4),
                        Text(
                          member['email'] ?? '',
                          style: TextStyle(
                            color: Color(0xFFE5A122).withOpacity(0.8),
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          member['domain'] ?? 'No domain',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: isTablet ? 24 : 20,
                      ),
                      onPressed:
                          () => _showDeleteDialog(context, provider, member),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.01),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      isApproved ? 'Approved for activation' : 'Tap to approve',
                      style: TextStyle(
                        color: isApproved ? Colors.green : Colors.white,
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: isTablet ? 1.2 : 1.0,
                    child: Switch(
                      value: isApproved,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withOpacity(0.3),
                      activeTrackColor: Colors.green.withOpacity(0.3),
                      onChanged: (value) {
                        provider.toggleMemberSelection(memberId);
                      },
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

  void _showDeleteDialog(
    BuildContext context,
    MemberManagementProvider provider,
    Map<String, dynamic> member,
  ) {
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
              width: isTablet ? screenWidth * 0.5 : screenWidth * 0.8,
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: isTablet ? 60 : 48,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Delete Member Request?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Are you sure you want to delete ${member['name']}\'s membership request? This action cannot be undone.',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 18 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey, width: 1),
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 12 : 8,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final success = await provider.deletePendingMember(
                              member['_id'],
                            );
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Member request deleted successfully',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to delete member request',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 12 : 8,
                              ),
                            ),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
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

  Future<void> _handleSubmit(
    BuildContext context,
    MemberManagementProvider provider,
  ) async {
    final success = await provider.submitApprovals();

    _showResultModal(
      context,
      success,
      successMessage: 'Member approvals submitted successfully!',
      errorMessage: provider.error ?? 'Failed to submit approvals',
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
              width: isTablet ? screenWidth * 0.5 : screenWidth * 0.8,
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color:
                          success
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
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
