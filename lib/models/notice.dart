class Notice {
  final String id;
  final String title;
  final String description;
  final String? attachmentLink;
  final String uploadedByName;
  final String uploadedByEmail;
  final DateTime uploadedAt;

  Notice({
    required this.id,
    required this.title,
    required this.description,
    this.attachmentLink,
    required this.uploadedByName,
    required this.uploadedByEmail,
    required this.uploadedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    // Defensive: handle missing or malformed uploadedBy
    final uploadedBy = json['uploadedBy'];
    String uploadedByName = '';
    String uploadedByEmail = '';
    if (uploadedBy is Map) {
      uploadedByName = uploadedBy['name']?.toString() ?? '';
      uploadedByEmail = uploadedBy['email']?.toString() ?? '';
    }

    // Defensive: handle missing or malformed uploadedAt
    DateTime uploadedAt;
    try {
      uploadedAt = DateTime.parse(json['uploadedAt'].toString());
    } catch (_) {
      uploadedAt = DateTime.now();
    }

    return Notice(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      attachmentLink: json['attachmentLink']?.toString(),
      uploadedByName: uploadedByName,
      uploadedByEmail: uploadedByEmail,
      uploadedAt: uploadedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'attachmentLink': attachmentLink,
      'uploadedBy': {
        'name': uploadedByName,
        'email': uploadedByEmail,
      },
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}
