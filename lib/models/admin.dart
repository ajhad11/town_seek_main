import 'app_role.dart';

class Admin {
  final String id;
  final String email;
  final AppRole role;
  final String? businessId;
  final bool isApproved;
  final DateTime createdAt;

  Admin({
    required this.id,
    required this.email,
    required this.role,
    this.businessId,
    this.isApproved = false,
    required this.createdAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      email: json['email'],
      role: AppRoleExtension.fromString(json['role']),
      businessId: json['business_id'],
      isApproved: json['is_approved'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.name,
      'business_id': businessId,
      'is_approved': isApproved,
    };
  }
}
