import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';

class ProjectProvider with ChangeNotifier {
  ProjectModel? _currentProject;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedTaskFilter = 'All';
  bool _isTeamLead = true;

  ProjectModel? get currentProject => _currentProject;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedTaskFilter => _selectedTaskFilter;
  bool get isTeamLead => _isTeamLead;

  List<ProjectTask> get filteredTasks {
    if (_currentProject == null) return [];
    if (_selectedTaskFilter == 'All') return _currentProject!.tasks;
    return _currentProject!.tasks
        .where((task) => task.status.toLowerCase() == _selectedTaskFilter.toLowerCase())
        .toList();
  }

  Future<void> fetchProjectDetails(String token, String projectId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentProject = await ProjectService.getProjectDetails(token, projectId);
    } catch (e) {
      _errorMessage = 'Failed to load project details: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTaskFilter(String filter) {
    _selectedTaskFilter = filter;
    notifyListeners();
  }

  void setIsTeamLead(bool status) {
    _isTeamLead = status;
    notifyListeners();
  }

  void refreshTimeline() {
    notifyListeners();
  }
}
