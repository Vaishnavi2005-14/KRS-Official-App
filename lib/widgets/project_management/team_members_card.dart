import 'package:flutter/material.dart';
import '../../models/project_model.dart';

class TeamMembersCard extends StatelessWidget {
  final List<ProjectMember> teamLeads;
  final List<ProjectMember> assignedMembers;

  const TeamMembersCard({
    super.key,
    required this.teamLeads,
    required this.assignedMembers,
  });

  @override
  Widget build(BuildContext context) {
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
            children: const [
              Icon(Icons.groups, color: Color(0xFFE5A122), size: 20),
              SizedBox(width: 8),
              Text(
                'TEAM MEMBERS & LEADS',
                style: TextStyle(
                  color: Color(0xFFE5A122),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (teamLeads.isNotEmpty) ...[
            const Text(
              'TEAM LEADS',
              style: TextStyle(
                color: Color(0xFFA0AEC0),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            ...teamLeads.map((member) => _buildMemberRow(member, isLead: true)),
            const SizedBox(height: 12),
          ],

          const Text(
            'ASSIGNED MEMBERS',
            style: TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          if (assignedMembers.isEmpty)
            const Text(
              'No members assigned yet.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            )
          else
            ...assignedMembers.map((member) => _buildMemberRow(member, isLead: false)),
        ],
      ),
    );
  }

  Widget _buildMemberRow(ProjectMember member, {required bool isLead}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isLead ? const Color(0xFFE5A122) : const Color(0xFF1B2A4A),
            child: Text(
              member.name.isNotEmpty ? member.name[0].toUpperCase() : 'M',
              style: TextStyle(
                color: isLead ? const Color(0xFF040E1E) : const Color(0xFFE5A122),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isLead) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5A122),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'TL',
                          style: TextStyle(
                            color: Color(0xFF040E1E),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  member.email,
                  style: const TextStyle(
                    color: Color(0xFFA0AEC0),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5A122), width: 0.8),
            ),
            child: Text(
              member.domain,
              style: const TextStyle(
                color: Color(0xFFE5A122),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
