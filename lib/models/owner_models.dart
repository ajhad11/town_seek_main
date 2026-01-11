class ShopStats {
  final int totalViews;
  final int wishlistCount;
  final int totalOrders;
  final double totalRevenue;
  final List<ChartPoint> weeklyViews;
  final List<ChartPoint> weeklyRevenue;

  final double rating;
  final double viewsComparison;
  final double revenueComparison;

  ShopStats({
    required this.totalViews,
    required this.wishlistCount,
    required this.totalOrders,
    required this.totalRevenue,
    required this.weeklyViews,
    required this.weeklyRevenue,
    this.rating = 0.0,
    this.viewsComparison = 0.0,
    this.revenueComparison = 0.0,
  });

  factory ShopStats.mock() {
    return ShopStats(
      totalViews: 4520,
      wishlistCount: 320,
      totalOrders: 145,
      totalRevenue: 12500.0,
      weeklyViews: [
        ChartPoint('Mon', 120),
        ChartPoint('Tue', 150),
        ChartPoint('Wed', 180),
        ChartPoint('Thu', 140),
        ChartPoint('Fri', 220),
        ChartPoint('Sat', 250),
        ChartPoint('Sun', 200),
      ],
      weeklyRevenue: [
        ChartPoint('Mon', 400),
        ChartPoint('Tue', 500),
        ChartPoint('Wed', 450),
        ChartPoint('Thu', 600),
        ChartPoint('Fri', 800),
        ChartPoint('Sat', 1200),
        ChartPoint('Sun', 950),
      ],
    );
  }
}

class ChartPoint {
  final String label;
  final double value;

  ChartPoint(this.label, this.value);
}

class ShopOffer {
  final String id;
  final String shopId;
  final String title;
  final String description;
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  ShopOffer({
    required this.id,
    required this.shopId,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'shop_id': shopId,
        'title': title,
        'description': description,
        'discount_percentage': discountPercentage,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'is_active': isActive,
      };

  factory ShopOffer.fromJson(Map<String, dynamic> json) {
    return ShopOffer(
      id: json['id'],
      shopId: json['shop_id'],
      title: json['title'],
      description: json['description'],
      discountPercentage: (json['discount_percentage'] ?? 0.0).toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'] ?? true,
    );
  }
}
