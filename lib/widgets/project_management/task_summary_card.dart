import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../providers/project_provider.dart';
import 'package:provider/provider.dart';

class TaskSummaryCard extends StatelessWidget {
  final List<ProjectTask> tasks;

  const TaskSummaryCard({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5A122), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.task_alt, color: Color(0xFFE5A122), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'TASK SUMMARY',
                    style: TextStyle(
                      color: Color(0xFFE5A122),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Text(
                'Total: ${tasks.length}',
                style: const TextStyle(
                  color: Color(0xFFA0AEC0),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'To-Do', 'In Progress', 'Review', 'Completed'].map((filter) {
                final isSelected = provider.selectedTaskFilter.toLowerCase() == filter.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF040E1E) : const Color(0xFFE5A122),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFFE5A122),
                    backgroundColor: const Color(0xFF040E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Color(0xFFE5A122), width: 1.0),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        provider.setTaskFilter(filter);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          if (provider.filteredTasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No tasks found for selected filter.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            )
          else
            ...provider.filteredTasks.map((task) => _buildTaskItem(task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(ProjectTask task) {
    Color statusColor;
    switch (task.status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.greenAccent;
        break;
      case 'in progress':
        statusColor = const Color(0xFFE5A122);
        break;
      case 'review':
        statusColor = Colors.orangeAccent;
        break;
      default:
        statusColor = const Color(0xFFA0AEC0);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF040E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5A122).withValues(alpha: 0.4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor, width: 0.8),
                ),
                child: Text(
                  task.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            task.description,
            style: const TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline, color: Color(0xFFE5A122), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    task.assignedTo,
                    style: const TextStyle(
                      color: Color(0xFFE5A122),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFFA0AEC0), size: 13),
                  const SizedBox(width: 4),
                  Text(
                    '${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                    style: const TextStyle(
                      color: Color(0xFFA0AEC0),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
