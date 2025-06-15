class Member {
  final String id;
  final String name;
  final String domain;
  final String roll;
  final String image;

  Member({
    required this.id,
    required this.name,
    required this.domain,
    required this.roll,
    required this.image,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      domain: json['domain'] ?? '',
      roll: json['roll']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'domain': domain,
      'roll': roll,
      'image': image,
    };
  }
}
