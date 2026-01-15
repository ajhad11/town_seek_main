class Service {
  final String id;
  final String businessId;
  final String name;
  final String? description;
  final double price;
  final int durationMinutes;
  final bool isAvailable;
  final String? imageUrl;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.businessId,
    required this.name,
    this.description,
    required this.price,
    required this.durationMinutes,
    required this.isAvailable,
    this.imageUrl,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      businessId: json['business_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0.0).toDouble(),
      durationMinutes: json['duration_minutes'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'name': name,
      'description': description,
      'price': price,
      'duration_minutes': durationMinutes,
      'is_available': isAvailable,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

