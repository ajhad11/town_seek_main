class Business {
  final String id;
  final String? ownerId;
  final String name;
  final String? description;
  final String? category;
  final String? imageUrl;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double rating;
  final List<String> tags;
  final bool isOpen;
  final Map<String, dynamic>? facilities;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  Business({
    required this.id,
    this.ownerId,
    required this.name,
    this.description,
    this.category,
    this.imageUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.rating = 0.0,
    this.tags = const [],
    this.isOpen = true,
    this.facilities,
    this.metadata,
    required this.createdAt,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['image_url'],
      address: json['address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      isOpen: json['is_open'] ?? true,
      facilities: json['facilities'] != null ? Map<String, dynamic>.from(json['facilities']) : null,
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'tags': tags,
      'is_open': isOpen,
      'facilities': facilities,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Business copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    List<String>? tags,
    bool? isOpen,
    Map<String, dynamic>? facilities,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return Business(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      isOpen: isOpen ?? this.isOpen,
      facilities: facilities ?? this.facilities,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
