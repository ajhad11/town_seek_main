class Doctor {
  final String id;
  final String hospitalId;
  final String name;
  final String specialization;
  final String? imageUrl;
  final Map<String, dynamic>? availability;
  final bool isActive;
  final DateTime createdAt;

  Doctor({
    required this.id,
    required this.hospitalId,
    required this.name,
    required this.specialization,
    this.imageUrl,
    this.availability,
    this.isActive = true,
    required this.createdAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      hospitalId: json['hospital_id'],
      name: json['name'],
      specialization: json['specialization'],
      imageUrl: json['image_url'],
      availability: json['availability'] != null ? Map<String, dynamic>.from(json['availability']) : null,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospital_id': hospitalId,
      'name': name,
      'specialization': specialization,
      'image_url': imageUrl,
      'availability': availability,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

