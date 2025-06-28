import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../providers/user_selection_provider.dart';
import '../../widgets/attendance/attendance_search_bar.dart';
import 'user_attendance_detail.dart';

class UserSelectionPage extends StatefulWidget {
  const UserSelectionPage({super.key});

  @override
  State<UserSelectionPage> createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  UserSelectionProvider? _provider;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMembers(UserSelectionProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty) {
      await provider.fetchMembers(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return ChangeNotifierProvider(
      create: (_) => UserSelectionProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'SELECT MEMBER',
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
                  Icons.people,
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
        body: Consumer<UserSelectionProvider>(
          builder: (context, provider, _) {
            if (_provider != provider) {
              _provider = provider;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _fetchMembers(provider);
              });
            }

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
                    placeholder: 'Search by name or roll number',
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
                            : provider.error != null
                            ? Center(
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
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: isTablet ? 20 : 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  ElevatedButton(
                                    onPressed: () {
                                      provider.clearError();
                                      _fetchMembers(provider);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFE5A122),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.06,
                                        vertical: isTablet ? 16 : 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          isTablet ? 12 : 8,
                                        ),
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
                            )
                            : provider.filteredMembers.isEmpty
                            ? Center(
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
                                    provider.searchQuery.isEmpty
                                        ? 'No members found'
                                        : 'No members match your search',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: isTablet ? 20 : 16,
                                    ),
                                  ),
                                  if (provider.allMembers.isEmpty &&
                                      !provider.isLoading) ...[
                                    SizedBox(height: screenHeight * 0.02),
                                    ElevatedButton(
                                      onPressed: () => _fetchMembers(provider),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFE5A122),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.06,
                                          vertical: isTablet ? 16 : 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            isTablet ? 12 : 8,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Load Members',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: isTablet ? 16 : 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.01,
                              ),
                              itemCount: provider.filteredMembers.length,
                              itemBuilder: (context, index) {
                                final member = provider.filteredMembers[index];
                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: screenHeight * 0.015,
                                  ),
                                  padding: EdgeInsets.all(screenWidth * 0.04),
                                  decoration: BoxDecoration(
                                    color: Color(0xff06132A),
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 16 : 12,
                                    ),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () => _selectMember(member),
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 16 : 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: isTablet ? 60 : 50,
                                          height: isTablet ? 60 : 50,
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xFFE5A122,
                                            ).withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: CircleAvatar(
                                            radius: isTablet ? 30 : 25,
                                            backgroundColor: Color(0xFFE5A122),
                                            backgroundImage:
                                                (member.image.isNotEmpty)
                                                    ? NetworkImage(member.image)
                                                    : null,
                                            child:
                                                (member.image.isEmpty)
                                                    ? Text(
                                                      member.name.isNotEmpty
                                                          ? member.name[0]
                                                              .toUpperCase()
                                                          : 'U',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            isTablet ? 22 : 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                    : null,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.04),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                member.name,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: isTablet ? 20 : 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.002,
                                              ),
                                              Text(
                                                member.domain,
                                                style: TextStyle(
                                                  color: Color(
                                                    0xFFE5A122,
                                                  ).withOpacity(0.8),
                                                  fontSize: isTablet ? 16 : 14,
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.001,
                                              ),
                                              Text(
                                                "Roll No: ${member.roll}",
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: isTablet ? 14 : 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFFE5A122),
                                          size: isTablet ? 24 : 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ),
              ],
            );
          },
        ),
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
                    SizedBox(height: 4),
                    Container(
                      width: screenWidth * 0.4,
                      height: isTablet ? 14 : 10,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectMember(member) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => UserAttendanceDetailPage(
                userId: member.id,
                userName: member.name,
                userDomain: member.domain,
                userImage: member.image,
                userRoll: member.roll,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication error. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
