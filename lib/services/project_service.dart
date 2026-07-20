import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';
import 'api_service.dart';

class ProjectService {
  static const String baseUrl = ApiService.baseUrl;

  static Future<ProjectModel> getProjectDetails(String token, String projectId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/projects/$projectId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ProjectModel.fromJson(data);
      } else {
        return _getDummyProjectDetails(projectId);
      }
    } catch (e) {
      return _getDummyProjectDetails(projectId);
    }
  }

  static ProjectModel _getDummyProjectDetails(String projectId) {
    return ProjectModel(
      id: projectId.isEmpty ? 'proj_krs_001' : projectId,
      title: 'KRS Official Mobile Application',
      description:
          'Comprehensive mobile application for KIIT Robotics Society members to track attendance, notices, MOMs, and project management workflows seamlessly.',
      projectType: 'App Development',
      domains: ['App Development', 'Web Development', 'Backend & API', 'UI/UX Design', 'Embedded Systems'],
      status: 'Active',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      deadline: DateTime.now().add(const Duration(days: 20)),
      teamLeads: [
        ProjectMember(
          id: 'tl_01',
          name: 'Vaishnavi Singh',
          email: 'vaishnavi@krs.org',
          role: 'Team Lead',
          domain: 'App Development',
        ),
        ProjectMember(
          id: 'tl_02',
          name: 'Ananya Sharma',
          email: 'ananya@krs.org',
          role: 'Team Lead',
          domain: 'UI/UX Design',
        ),
      ],
      assignedMembers: [
        ProjectMember(
          id: 'mem_01',
          name: 'Abhishek Kumar',
          email: 'abhishek@krs.org',
          role: 'Member',
          domain: 'Backend & API',
        ),
        ProjectMember(
          id: 'mem_02',
          name: 'Tejashwini Roy',
          email: 'tejashwini@krs.org',
          role: 'Member',
          domain: 'Web Development',
        ),
        ProjectMember(
          id: 'mem_03',
          name: 'Akash Das',
          email: 'akash@krs.org',
          role: 'Member',
          domain: 'App Development',
        ),
        ProjectMember(
          id: 'mem_04',
          name: 'Subham Mukherjee',
          email: 'subham@krs.org',
          role: 'Member',
          domain: 'Full Stack',
        ),
        ProjectMember(
          id: 'mem_05',
          name: 'Arijit Paul',
          email: 'arijit@krs.org',
          role: 'Member',
          domain: 'App Development',
        ),
      ],
      tasks: [
        ProjectTask(
          id: 't_01',
          title: 'Project Details View (Screen 3)',
          description: 'Implement Project Details layout, team display, progress bar, task summary & activity timeline.',
          assignedTo: 'Vaishnavi Singh',
          assignedToDomain: 'App Development',
          status: 'In Progress',
          priority: 'High',
          deadline: DateTime.now().add(const Duration(days: 3)),
        ),
        ProjectTask(
          id: 't_02',
          title: 'Dashboard & Navigation (Screen 1)',
          description: 'Project Cards layout showing Active & Archived Projects with search & filters.',
          assignedTo: 'Ananya Sharma',
          assignedToDomain: 'UI/UX Design',
          status: 'Completed',
          priority: 'High',
          deadline: DateTime.now().subtract(const Duration(days: 2)),
        ),
        ProjectTask(
          id: 't_03',
          title: 'Project Creation Form (Screen 2)',
          description: 'Create Project Screen layout, form fields, domain selection and validation.',
          assignedTo: 'Abhishek Kumar',
          assignedToDomain: 'Backend & API',
          status: 'Completed',
          priority: 'Medium',
          deadline: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ProjectTask(
          id: 't_04',
          title: 'Project Editing Screen (Screen 4)',
          description: 'Edit Project screen UI, controls to add/remove members and update deadlines.',
          assignedTo: 'Tejashwini Roy',
          assignedToDomain: 'Web Development',
          status: 'To-Do',
          priority: 'Medium',
          deadline: DateTime.now().add(const Duration(days: 5)),
        ),
        ProjectTask(
          id: 't_05',
          title: 'Task Management & Status Portal (Screen 5)',
          description: 'Task Creation & Assignment list, status updates checklist and progress logic.',
          assignedTo: 'Akash Das',
          assignedToDomain: 'App Development',
          status: 'In Progress',
          priority: 'High',
          deadline: DateTime.now().add(const Duration(days: 4)),
        ),
        ProjectTask(
          id: 't_06',
          title: 'Updates & Attachments Interface (Screen 6)',
          description: 'Add update feature, GitHub link field, image upload container, and history card view.',
          assignedTo: 'Subham Mukherjee',
          assignedToDomain: 'Full Stack',
          status: 'Review',
          priority: 'Medium',
          deadline: DateTime.now().add(const Duration(days: 2)),
        ),
        ProjectTask(
          id: 't_07',
          title: 'Approval Portal & Notification Center (Screen 7)',
          description: 'Team lead approval portal, approve/reject UI, role-based route permissions and notifications.',
          assignedTo: 'Arijit Paul',
          assignedToDomain: 'App Development',
          status: 'To-Do',
          priority: 'High',
          deadline: DateTime.now().add(const Duration(days: 6)),
        ),
      ],
      activityTimeline: [
        ProjectActivity(
          id: 'act_01',
          authorName: 'Subham Mukherjee',
          authorRole: 'Member',
          title: 'Submitted Task Update for Review',
          description: 'Added GitHub attachment link for Updates & Attachments Interface (Screen 6) and uploaded proof screenshots.',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          type: 'update',
          githubUrl: 'https://github.com/KIIT-Robotics-Society-App-Dev/KRS-App',
        ),
        ProjectActivity(
          id: 'act_02',
          authorName: 'Arijit Paul',
          authorRole: 'Team Lead',
          title: 'Approved Project Creation Workflow',
          description: 'Verified MongoDB payload integration and approved Screen 2 implementation.',
          timestamp: DateTime.now().subtract(const Duration(hours: 14)),
          type: 'task_completed',
        ),
        ProjectActivity(
          id: 'act_03',
          authorName: 'Vaishnavi Singh',
          authorRole: 'Team Lead',
          title: 'Updated Project Architecture Guidelines',
          description: 'Configured project workflow phases and team member role distribution.',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          type: 'update',
        ),
        ProjectActivity(
          id: 'act_04',
          authorName: 'Ananya Sharma',
          authorRole: 'Team Lead',
          title: 'Completed Dashboard Listing Module',
          description: 'Active & Archived project card visualization ready with search & filter options.',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          type: 'task_completed',
        ),
      ],
    );
  }
}
