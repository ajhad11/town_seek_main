import 'package:town_seek/services/supabase_service.dart';

/// Admin-specific service for handling super admin operations
/// Only accessible to ajhadk453@gmail.com
class AdminService {
  static const String superAdminEmail = 'ajhadk453@gmail.com';

  /// Verify if current user is super admin
  static bool isSuperAdmin() {
    final user = SupabaseService.currentUser;
    return user?.email == superAdminEmail;
  }

  /// Get admin dashboard statistics
  static Future<AdminStats> getDashboardStats() async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      // In real implementation, fetch from Supabase
      return AdminStats(
        totalUsers: 12456,
        totalShops: 3847,
        totalHospitals: 542,
        totalServices: 8932,
        activePromotions: 156,
        todaySearches: 5243,
        pendingReviews: 23,
        systemHealth: 98.5,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Log admin action for audit trail
  static Future<void> logAdminAction({
    required String action,
    required String targetTable,
    required String targetId,
    required Map<String, dynamic> changes,
  }) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      // TODO: Implement logging to admin_logs table
      // In production, use a proper logger or send to Supabase
    } catch (e) {
      rethrow;
    }
  }

  /// Get users for management
  static Future<List<AdminUserData>> getUsers({
    String? searchQuery,
    int limit = 50,
  }) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      // TODO: Implement Supabase query
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Update user status
  static Future<void> updateUserStatus({
    required String userId,
    required bool isActive,
  }) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: isActive ? 'ACTIVATE_USER' : 'DEACTIVATE_USER',
        targetTable: 'users',
        targetId: userId,
        changes: {'is_active': isActive},
      );

      // TODO: Implement Supabase update
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user permanently
  static Future<void> deleteUser(String userId) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: 'DELETE_USER',
        targetTable: 'users',
        targetId: userId,
        changes: {'deleted': true},
      );

      // TODO: Implement Supabase delete with cascade
    } catch (e) {
      rethrow;
    }
  }

  /// Get shops for management
  static Future<List<AdminShopData>> getShops({
    String? status,
    int limit = 50,
  }) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      // TODO: Implement Supabase query with filters
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Approve shop registration
  static Future<void> approveShop(String shopId) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: 'APPROVE_SHOP',
        targetTable: 'shops',
        targetId: shopId,
        changes: {'is_verified': true},
      );

      // TODO: Implement Supabase update
    } catch (e) {
      rethrow;
    }
  }

  /// Suspend shop
  static Future<void> suspendShop(String shopId, String reason) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: 'SUSPEND_SHOP',
        targetTable: 'shops',
        targetId: shopId,
        changes: {'status': 'suspended', 'suspend_reason': reason},
      );

      // TODO: Implement Supabase update
    } catch (e) {
      rethrow;
    }
  }

  /// Get reviews for moderation
  static Future<List<AdminReviewData>> getReviews({
    String? status, // pending, approved, flagged
    int limit = 50,
  }) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      // TODO: Implement Supabase query with filters
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Approve review
  static Future<void> approveReview(String reviewId) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: 'APPROVE_REVIEW',
        targetTable: 'reviews',
        targetId: reviewId,
        changes: {'status': 'approved'},
      );

      // TODO: Implement Supabase update
    } catch (e) {
      rethrow;
    }
  }

  /// Flag review as suspicious
  static Future<void> flagReview(String reviewId, String reason) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: 'FLAG_REVIEW',
        targetTable: 'reviews',
        targetId: reviewId,
        changes: {'is_flagged': true, 'flag_reason': reason},
      );

      // TODO: Implement Supabase update
    } catch (e) {
      rethrow;
    }
  }

  /// Delete review
  static Future<void> deleteReview(String reviewId, String reason) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: 'DELETE_REVIEW',
        targetTable: 'reviews',
        targetId: reviewId,
        changes: {'deletion_reason': reason},
      );

      // TODO: Implement Supabase delete
    } catch (e) {
      rethrow;
    }
  }

  /// Get promotions
  static Future<List<AdminPromotionData>> getPromotions({
    bool? isActive,
    int limit = 50,
  }) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      // TODO: Implement Supabase query
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Update promotion
  static Future<void> updatePromotion({
    required String promotionId,
    required bool isActive,
  }) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: isActive ? 'ACTIVATE_PROMOTION' : 'DEACTIVATE_PROMOTION',
        targetTable: 'promotions',
        targetId: promotionId,
        changes: {'is_active': isActive},
      );

      // TODO: Implement Supabase update
    } catch (e) {
      rethrow;
    }
  }

  /// Get analytics data
  static Future<AnalyticsData> getAnalytics({
    required String period, // week, month, year
  }) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      // TODO: Implement Supabase queries for analytics
      return AnalyticsData(
        mostSearchedItems: ['Electronics', 'Fashion', 'Food'],
        highDemandLocations: ['Downtown', 'Mall Center', 'Uptown'],
        clickToVisitRatio: 68.0,
        avgSessionDuration: '4m 23s',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get system settings
  static Future<SystemSettings> getSystemSettings() async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      // TODO: Fetch from database or cache
      return SystemSettings(
        maintenanceMode: false,
        analyticsEnabled: true,
        notificationsEnabled: true,
        categories: [],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Update system settings
  static Future<void> updateSystemSettings(SystemSettings settings) async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: 'UPDATE_SETTINGS',
        targetTable: 'settings',
        targetId: 'system',
        changes: settings.toJson(),
      );

      // TODO: Implement Supabase update
    } catch (e) {
      rethrow;
    }
  }

  /// Export users data
  static Future<String> exportUsersData() async {
    try {
      if (!isSuperAdmin()) throw 'Unauthorized access';

      await logAdminAction(
        action: 'EXPORT_USERS',
        targetTable: 'users',
        targetId: 'all',
        changes: {'format': 'csv', 'timestamp': DateTime.now().toString()},
      );

      // TODO: Generate CSV and return
      return 'users_export.csv';
    } catch (e) {
      rethrow;
    }
  }
}

// Data Models

class AdminStats {
  final int totalUsers;
  final int totalShops;
  final int totalHospitals;
  final int totalServices;
  final int activePromotions;
  final int todaySearches;
  final int pendingReviews;
  final double systemHealth;

  AdminStats({
    required this.totalUsers,
    required this.totalShops,
    required this.totalHospitals,
    required this.totalServices,
    required this.activePromotions,
    required this.todaySearches,
    required this.pendingReviews,
    required this.systemHealth,
  });
}

class AdminUserData {
  final String id;
  final String name;
  final String email;
  final bool isActive;
  final DateTime createdAt;

  AdminUserData({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    required this.createdAt,
  });
}

class AdminShopData {
  final String id;
  final String name;
  final String owner;
  final String location;
  final double rating;
  final String status;
  final int productCount;
  final DateTime createdAt;

  AdminShopData({
    required this.id,
    required this.name,
    required this.owner,
    required this.location,
    required this.rating,
    required this.status,
    required this.productCount,
    required this.createdAt,
  });
}

class AdminReviewData {
  final String id;
  final String author;
  final String shop;
  final int rating;
  final String text;
  final String status;
  final DateTime createdAt;

  AdminReviewData({
    required this.id,
    required this.author,
    required this.shop,
    required this.rating,
    required this.text,
    required this.status,
    required this.createdAt,
  });
}

class AdminPromotionData {
  final String id;
  final String shopName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final double monthlyCharge;
  final int clicks;

  AdminPromotionData({
    required this.id,
    required this.shopName,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.monthlyCharge,
    required this.clicks,
  });
}

class AnalyticsData {
  final List<String> mostSearchedItems;
  final List<String> highDemandLocations;
  final double clickToVisitRatio;
  final String avgSessionDuration;

  AnalyticsData({
    required this.mostSearchedItems,
    required this.highDemandLocations,
    required this.clickToVisitRatio,
    required this.avgSessionDuration,
  });
}

class SystemSettings {
  bool maintenanceMode;
  bool analyticsEnabled;
  bool notificationsEnabled;
  List<String> categories;

  SystemSettings({
    required this.maintenanceMode,
    required this.analyticsEnabled,
    required this.notificationsEnabled,
    required this.categories,
  });

  Map<String, dynamic> toJson() => {
    'maintenance_mode': maintenanceMode,
    'analytics_enabled': analyticsEnabled,
    'notifications_enabled': notificationsEnabled,
    'categories': categories,
  };

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
    maintenanceMode: json['maintenance_mode'] ?? false,
    analyticsEnabled: json['analytics_enabled'] ?? true,
    notificationsEnabled: json['notifications_enabled'] ?? true,
    categories: List<String>.from(json['categories'] ?? []),
  );
}
