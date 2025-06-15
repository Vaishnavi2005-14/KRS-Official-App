import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:krs_app/providers/attendance_provider.dart';

class AttendanceMemberCard extends StatelessWidget {
  final dynamic member;
  final List<String> statuses;

  const AttendanceMemberCard({
    Key? key,
    required this.member,
    required this.statuses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);
    final selectedStatus = provider.selectedStatus[member.id] ?? statuses[0];
    final remarkController = provider.getRemarkController(member.id);

    return Slidable(
      key: ValueKey(member.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              provider.updateStatus(member.id, 'Absent with reason');
              provider.setEditingRemarks(member.id, true);
            },
            label: "With Reason",
            icon: Icons.sticky_note_2,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              provider.updateStatus(member.id, 'Present');
              provider.setEditingRemarks(member.id, false);
              provider.clearRemarkForMember(member.id);
            },
            label: "Present",
            icon: Icons.check_circle,
            backgroundColor: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          SlidableAction(
            onPressed: (context) {
              provider.updateStatus(member.id, 'Absent');
              provider.setEditingRemarks(member.id, false);
              provider.clearRemarkForMember(member.id);
            },
            label: "Absent",
            icon: Icons.cancel,
            backgroundColor: Colors.red.withAlpha(100),
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xff151E2D),
          border: Border.all(width: 2, color: const Color(0xffE5A122)),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 24,
                  child: ClipOval(
                    child: Image(
                      image: NetworkImage(member.image.toString()),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
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
                        color: Color(0xffE5A122),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Roll ${member.roll}',
                      style: const TextStyle(color: Color(0xffE5A122)),
                    ),
                    Text(
                      '${member.domain}',
                      style: const TextStyle(color: Color(0xffE5A122)),
                    ),
                  ],
                ),
              ],
            ),
            if (selectedStatus == 'Absent with reason')
              ...[
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
