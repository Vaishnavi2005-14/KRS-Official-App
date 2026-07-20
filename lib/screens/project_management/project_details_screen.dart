import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/project_provider.dart';
import '../../widgets/project_management/project_progress_card.dart';
import '../../widgets/project_management/team_members_card.dart';
import '../../widgets/project_management/task_summary_card.dart';
import '../../widgets/project_management/activity_timeline_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailsScreen({super.key, this.projectId = 'proj_krs_001'});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (mounted) {
      Provider.of<ProjectProvider>(context, listen: false).fetchProjectDetails(token, widget.projectId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final project = projectProvider.currentProject;

    return Scaffold(
      backgroundColor: const Color(0xFF040E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF040E1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFE5A122)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'PROJECT DETAILS',
          style: TextStyle(
            color: Color(0xFFE5A122),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFE5A122)),
            onPressed: () => _loadData(),
          ),
        ],
      ),
      body: projectProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE5A122)),
            )
          : project == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Color(0xFFE5A122), size: 48),
                      const SizedBox(height: 12),
                      const Text(
                        'Unable to load project details',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5A122),
                          foregroundColor: const Color(0xFF040E1E),
                        ),
                        onPressed: () => _loadData(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFFE5A122),
                  backgroundColor: const Color(0xFF0D1B2A),
                  onRefresh: () => _loadData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProjectHeaderBanner(context, projectProvider),
                        const SizedBox(height: 16),
                        _buildActionNavigationRow(context, projectProvider),
                        const SizedBox(height: 20),
                        ProjectProgressCard(project: project),
                        const SizedBox(height: 20),
                        TeamMembersCard(
                          teamLeads: project.teamLeads,
                          assignedMembers: project.assignedMembers,
                        ),
                        const SizedBox(height: 20),
                        TaskSummaryCard(tasks: project.tasks),
                        const SizedBox(height: 20),
                        ActivityTimelineWidget(activities: project.activityTimeline),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProjectHeaderBanner(BuildContext context, ProjectProvider provider) {
    final project = provider.currentProject!;
    final int daysLeft = project.deadline.difference(DateTime.now()).inDays;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5A122), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE5A122).withValues(alpha: 0.15),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5A122),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  project.projectType.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF040E1E),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5A122)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Color(0xFFE5A122), size: 8),
                    const SizedBox(width: 6),
                    Text(
                      project.status,
                      style: const TextStyle(
                        color: Color(0xFFE5A122),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            project.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: const TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: project.domains.map((domain) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5A122).withValues(alpha: 0.6), width: 0.8),
                ),
                child: Text(
                  domain,
                  style: const TextStyle(
                    color: Color(0xFFE5A122),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFF1B2A4A)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: Color(0xFFE5A122), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    daysLeft >= 0 ? '$daysLeft Days Remaining' : 'Deadline Passed',
                    style: const TextStyle(
                      color: Color(0xFFE5A122),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                'Due: ${project.deadline.day}/${project.deadline.month}/${project.deadline.year}',
                style: const TextStyle(
                  color: Color(0xFFA0AEC0),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionNavigationRow(BuildContext context, ProjectProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            if (provider.isTeamLead)
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFE5A122), width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  icon: const Icon(Icons.edit_note, color: Color(0xFFE5A122), size: 18),
                  label: const Text(
                    'Edit Project',
                    style: TextStyle(
                      color: Color(0xFFE5A122),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await Navigator.pushNamed(context, '/project-edit', arguments: widget.projectId);
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Navigating to Project Edit Screen...'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            if (provider.isTeamLead) const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color(0xFFE5A122),
                  foregroundColor: const Color(0xFF040E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: const Icon(Icons.add_task, color: Color(0xFF040E1E), size: 18),
                label: const Text(
                  'Add Task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                onPressed: () async {
                  try {
                    await Navigator.pushNamed(context, '/add-task', arguments: widget.projectId);
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Navigating to Task Creation Portal...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Color(0xFFE5A122), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            icon: const Icon(Icons.post_add, color: Color(0xFFE5A122), size: 18),
            label: const Text(
              'Add Progress Update & Attachments',
              style: TextStyle(
                color: Color(0xFFE5A122),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            onPressed: () async {
              try {
                await Navigator.pushNamed(context, '/add-update', arguments: widget.projectId);
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navigating to Updates & Attachments Interface...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              }
              provider.refreshTimeline();
            },
          ),
        ),
      ],
    );
  }
}
