import 'package:flutter/material.dart';
import '../../models/project_model.dart';

class ProjectProgressCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectProgressCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final double percent = project.progressPercentage;
    final int completed = project.completedTaskCount;
    final int total = project.tasks.length;
    final int inProgress = project.inProgressTaskCount;
    final int review = project.reviewTaskCount;
    final int todo = project.todoTaskCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5A122), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE5A122).withValues(alpha: 0.12),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PROJECT PROGRESS',
                style: TextStyle(
                  color: Color(0xFFE5A122),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5A122).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5A122)),
                ),
                child: Text(
                  '${percent.toStringAsFixed(0)}% Done',
                  style: const TextStyle(
                    color: Color(0xFFE5A122),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 10,
              backgroundColor: const Color(0xFF1B2A4A),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE5A122)),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('Tasks', '$completed/$total', Icons.assignment_turned_in),
              _buildMetricItem('In Progress', '$inProgress', Icons.sync),
              _buildMetricItem('In Review', '$review', Icons.rate_review),
              _buildMetricItem('To-Do', '$todo', Icons.pending_actions),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFE5A122), size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFA0AEC0),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
