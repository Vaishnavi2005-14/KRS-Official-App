import 'package:flutter/material.dart';
import 'package:krs_app/providers/attendance_provider.dart';
import 'package:provider/provider.dart';


class AttendanceMemberCard extends StatelessWidget {
  final dynamic member;
  final List<String> statuses;

  const AttendanceMemberCard({
    super.key,
    required this.member,
    required this.statuses,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);
    final selectedStatus = provider.selectedStatus[member.id] ?? statuses[0];
    final remarkController = provider.getRemarkController(member.id);

    Color getStatusTint(String status) {
      switch (status) {
        case 'Absent':
          return const Color.fromARGB(255, 173, 51, 51);
        case 'With Reason':
          return const Color.fromARGB(255, 198, 145, 66);
        case 'Online':
          return const Color(0xFF2A4A7A);
        case 'Present':
        default:
          return const Color.fromARGB(255, 30, 168, 135);
      }
    }

    Icon? getStatusIcon(String status) {
      const iconSize = 20.0;
      switch (status) {
        case 'Absent':
          return const Icon(Icons.close, color: Colors.white, size: iconSize);
        case 'With Reason':
          return const Icon(
            Icons.sticky_note_2,
            color: Colors.white,
            size: iconSize,
          );
        case 'Online':
          return const Icon(Icons.wifi, color: Colors.white, size: iconSize);
        case 'Present':
        default:
          return null;
      }
    }

    return Card(
      color: const Color(0xFF040E1E),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.amberAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF040E1E),
                  radius: 24,
                  child: Text(
                    member.name.isNotEmpty ? member.name[0].toUpperCase() : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Roll #${member.rollNo} • ${member.domain}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  statuses.map((status) {
                    final isSelected = selectedStatus == status;
                    final backgroundColor = getStatusTint(status);

                    return SizedBox(
                      height: 40,
                      child: ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Remove the icon for selected status
                            // Only show the icon for status type, not for selection
                            if (getStatusIcon(status) != null) ...[
                              getStatusIcon(status)!,
                              const SizedBox(width: 6),
                            ],
                            Flexible(
                              child: Text(
                                status,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        selected: isSelected,
                        showCheckmark:
                            false, // <-- This disables the default tick mark
                        onSelected: (_) {
                          provider.updateStatus(member.id, status);
                          provider.setEditingRemarks(member.id, false);
                          if (status != 'Absent') {
                            provider.clearRemarkForMember(member.id);
                          }
                        },
                        selectedColor: backgroundColor,
                        backgroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected ? Colors.white : backgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            if (selectedStatus == 'Absent') ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final tempController = TextEditingController(
                            text: remarkController.text,
                          );
                          return AlertDialog(
                            backgroundColor: const Color(0xFF040E1E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Colors.amberAccent,
                                width: 2,
                              ),
                            ),
                            title: const Text(
                              'Enter Remark',
                              style: TextStyle(color: Colors.orange),
                            ),
                            content: TextField(
                              controller: tempController,
                              maxLines: 3,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Type the reason...',
                                hintStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                filled: true,
                                fillColor: const Color(0xFF040E1E),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  provider.updateRemark(
                                    member.id,
                                    tempController.text,
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Add Remarks'),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
