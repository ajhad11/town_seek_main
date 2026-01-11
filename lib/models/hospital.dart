class Hospital {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['image_url'],
      isActive: json['is_active'] == 1 || json['is_active'] == true, // Handle int or bool
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
