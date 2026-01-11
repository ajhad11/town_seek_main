class Product {
  final String id;
  final String businessId;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final String category;
  final int stockQuantity;
  final bool isAvailable;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.businessId,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.category = 'General',
    this.stockQuantity = 0,
    required this.isAvailable,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      businessId: json['business_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'],
      category: json['category'] ?? 'General',
      stockQuantity: json['stock_quantity'] ?? 0,
      isAvailable: json['is_available'] ?? true,
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
      'image_url': imageUrl,
      'category': category,
      'stock_quantity': stockQuantity,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
