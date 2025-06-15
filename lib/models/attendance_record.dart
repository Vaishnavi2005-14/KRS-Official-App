// attendance_record.dart
class AttendanceRecord {
  final String userId;
  final String name;
  final String domain;
  final String status;
  final String rollNo;
  final String? remarks;

  AttendanceRecord({
    required this.userId,
    required this.name,
    required this.domain,
    required this.status,
    required this.rollNo,
    this.remarks,
  });

  AttendanceRecord copyWith({
    String? userId,
    String? name,
    String? domain,
    String? status,
    String? rollNo,
    String? remarks,
  }) {
    return AttendanceRecord(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      domain: domain ?? this.domain,
      status: status ?? this.status,
      rollNo: rollNo ?? this.rollNo,
      remarks: remarks ?? this.remarks,
    );
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return AttendanceRecord(
      userId: user['_id']?.toString() ?? '',
      name: user['name'] ?? '',
      domain: user['domain'] ?? '',
      status: json['status'] ?? '',
      rollNo: user['roll']?.toString() ?? '',
      remarks: json['remarks']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'domain': domain,
      'status': status,
      'roll': rollNo,
      if (remarks != null) 'remarks': remarks,
    };
  }
}
