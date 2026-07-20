class ProjectMember {
  final String id;
  final String name;
  final String email;
  final String role;
  final String domain;
  final String? avatarUrl;

  ProjectMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.domain,
    this.avatarUrl,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Member',
      domain: json['domain'] ?? 'General',
      avatarUrl: json['avatarUrl'] ?? json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'domain': domain,
      'avatarUrl': avatarUrl,
    };
  }
}

class ProjectTask {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  final String assignedToDomain;
  final String status;
  final String priority;
  final DateTime deadline;

  ProjectTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.assignedToDomain,
    required this.status,
    required this.priority,
    required this.deadline,
  });

  factory ProjectTask.fromJson(Map<String, dynamic> json) {
    return ProjectTask(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      assignedTo: json['assignedTo'] ?? 'Unassigned',
      assignedToDomain: json['assignedToDomain'] ?? 'App Dev',
      status: json['status'] ?? 'To-Do',
      priority: json['priority'] ?? 'Medium',
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : DateTime.now().add(const Duration(days: 7)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'assignedToDomain': assignedToDomain,
      'status': status,
      'priority': priority,
      'deadline': deadline.toIso8601String(),
    };
  }
}

class ProjectActivity {
  final String id;
  final String authorName;
  final String authorRole;
  final String? authorAvatar;
  final String title;
  final String description;
  final DateTime timestamp;
  final String type;
  final String? githubUrl;
  final String? proofImageUrl;

  ProjectActivity({
    required this.id,
    required this.authorName,
    required this.authorRole,
    this.authorAvatar,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.githubUrl,
    this.proofImageUrl,
  });

  factory ProjectActivity.fromJson(Map<String, dynamic> json) {
    return ProjectActivity(
      id: json['_id'] ?? json['id'] ?? '',
      authorName: json['authorName'] ?? 'Member',
      authorRole: json['authorRole'] ?? 'Member',
      authorAvatar: json['authorAvatar'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      type: json['type'] ?? 'update',
      githubUrl: json['githubUrl'],
      proofImageUrl: json['proofImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorAvatar': authorAvatar,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'githubUrl': githubUrl,
      'proofImageUrl': proofImageUrl,
    };
  }
}

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String projectType;
  final List<String> domains;
  final String status;
  final DateTime startDate;
  final DateTime deadline;
  final List<ProjectMember> teamLeads;
  final List<ProjectMember> assignedMembers;
  final List<ProjectTask> tasks;
  final List<ProjectActivity> activityTimeline;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.projectType,
    required this.domains,
    required this.status,
    required this.startDate,
    required this.deadline,
    required this.teamLeads,
    required this.assignedMembers,
    required this.tasks,
    required this.activityTimeline,
  });

  double get progressPercentage {
    if (tasks.isEmpty) return 0.0;
    int completed = tasks.where((t) => t.status == 'Completed').length;
    return (completed / tasks.length) * 100;
  }

  int get completedTaskCount => tasks.where((t) => t.status == 'Completed').length;
  int get inProgressTaskCount => tasks.where((t) => t.status == 'In Progress').length;
  int get reviewTaskCount => tasks.where((t) => t.status == 'Review').length;
  int get todoTaskCount => tasks.where((t) => t.status == 'To-Do').length;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      projectType: json['projectType'] ?? 'Software',
      domains: json['domains'] != null ? List<String>.from(json['domains']) : [],
      status: json['status'] ?? 'Active',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : DateTime.now().add(const Duration(days: 30)),
      teamLeads: json['teamLeads'] != null
          ? (json['teamLeads'] as List).map((m) => ProjectMember.fromJson(m)).toList()
          : [],
      assignedMembers: json['assignedMembers'] != null
          ? (json['assignedMembers'] as List).map((m) => ProjectMember.fromJson(m)).toList()
          : [],
      tasks: json['tasks'] != null
          ? (json['tasks'] as List).map((t) => ProjectTask.fromJson(t)).toList()
          : [],
      activityTimeline: json['activityTimeline'] != null
          ? (json['activityTimeline'] as List).map((a) => ProjectActivity.fromJson(a)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'projectType': projectType,
      'domains': domains,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'teamLeads': teamLeads.map((m) => m.toJson()).toList(),
      'assignedMembers': assignedMembers.map((m) => m.toJson()).toList(),
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'activityTimeline': activityTimeline.map((a) => a.toJson()).toList(),
    };
  }
}
