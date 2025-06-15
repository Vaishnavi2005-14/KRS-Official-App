import 'attendance_record.dart';

class Attendance {
  final String id;
  final String date;
  final String topic;
  final String? categoryType;
  final String? team;
  final List<AttendanceRecord> attendanceRecords;

  Attendance({
    required this.id,
    required this.date,
    required this.topic,
    this.categoryType,
    this.team,
    required this.attendanceRecords,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['_id']?.toString() ?? '',
      date: json['date'] ?? '',
      topic: json['topic'] ?? '',
      categoryType: json['categoryType'],
      team: json['team'],
      attendanceRecords: (json['attendanceRecords'] ?? json['attendance_records'] ?? [])
          .map<AttendanceRecord>((item) => AttendanceRecord.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date,
      'topic': topic,
      if (categoryType != null) 'categoryType': categoryType,
      if (team != null) 'team': team,
      'attendanceRecords': attendanceRecords.map((e) => e.toJson()).toList(),
    };
  }
}