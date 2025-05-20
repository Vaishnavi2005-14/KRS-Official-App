class Member {
  final String id;
  final String name;
  final String domain;
  final String rollNo;

  Member({
    required this.id,
    required this.name,
    required this.domain,
    required this.rollNo,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '', // Fix key casing: it's lowercase in the response
      domain: json['domain'] ?? '',
      rollNo: json['roll']?.toString() ?? '', // Convert int to string safely
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'domain': domain,
      'roll': rollNo,
    };
  }
}
