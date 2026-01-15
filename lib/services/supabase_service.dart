import 'dart:async';
import 'dart:convert';
import '../models/user_profile.dart';
import '../models/business.dart';
import '../models/product.dart';
import '../models/service.dart';
import '../models/booking.dart';
import '../models/review.dart';
import '../models/auth_models.dart';
import '../models/admin.dart';
import '../models/hospital.dart';
import '../models/doctor.dart';
import 'database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes to replace Supabase types
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class Supabase {
  static final instance = Supabase();
  final client = _SupabaseClient();
}

class _SupabaseClient {
  final auth = _SupabaseAuth();
}

class _SupabaseAuth {
  User? currentUser;
  Stream<AuthState> get onAuthStateChange => const Stream.empty(); // Mock stream
  
  // These will be replaced by direct calls in SupabaseService static methods
}

class User {
  final String id;
  final String? email;
  User({required this.id, this.email});
}

class AuthState {
  final Session? session;
  AuthState({this.session});
}

class Session {
  final User user;
  Session({required this.user});
}

class OtpType {
  static const signup = 'signup';
}


/// This service uses local SQLite database but mimics SupabaseService interface.
class SupabaseService {
  static final _uuid = Uuid();
  static AppUser? _currentUser;
  
  // Helper to get DB instance
  static Future<dynamic> get _db async => await DatabaseHelper.instance.database;
  
  static final _authController = StreamController<AppAuthState>.broadcast();

  static Future<void> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('current_user_id');
      
      if (userId != null) {
        final db = await _db;
        final List<Map<String, dynamic>> users = await db.query(
          'auth_users',
          where: 'id = ?',
          whereArgs: [userId],
        );
        
        if (users.isNotEmpty) {
          final user = users.first;
          _currentUser = AppUser(id: user['id'], email: user['email']);
        }
      }
    } catch (e) {
      // Ignore errors during restore
    }
  }

  // --- Auth Operations ---

  static Future<void> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    final db = await _db;
    final userId = _uuid.v4();
    final now = DateTime.now().toIso8601String();
    
    // Check if user exists
    final List<Map<String, dynamic>> existing = await db.query(
      'auth_users',
      where: 'email = ?',
      whereArgs: [email],
    );
    
    if (existing.isNotEmpty) {
      throw AuthException('User already exists');
    }

    await db.insert('auth_users', {
      'id': userId,
      'email': email,
      'password': password, 
      'created_at': now,
    });
    
    // Create profile
    String role = 'user';
    if (data != null && data['role'] != null) {
      role = data['role'];
    }
    
    await db.insert('user_profiles', {
      'id': userId,
      'email': email,
      'full_name': data?['full_name'],
      'role': role,
      'created_at': now,
    });
    
    _currentUser = AppUser(id: userId, email: email);
    
    // Persist session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_id', userId);
    
    _notifyAuthState();
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final db = await _db;
    final List<Map<String, dynamic>> users = await db.query(
      'auth_users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    
    if (users.isEmpty) {
      throw AuthException('Invalid credentials');
    }
    
    final user = users.first;
    _currentUser = AppUser(id: user['id'], email: user['email']);
    
    // Update last sign in
    await db.update(
      'auth_users',
      {'last_sign_in_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [user['id']],
    );

    // Persist session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_id', user['id']);

    _notifyAuthState();
  }

  static Future<void> signOut() async {
    _currentUser = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user_id');
    } catch (_) {}
    _notifyAuthState();
  }

  static void _notifyAuthState() {
    if (_currentUser != null) {
      _authController.add(AppAuthState(
        session: AppSession(user: _currentUser!)
      ));
    } else {
      _authController.add(AppAuthState(session: null));
    }
  }

  static Future<void> resendVerificationEmail(String email) async {
    // No-op for local DB
  }

  static AppUser? get currentUser => _currentUser;

  static Stream<AppAuthState> get authStateChanges async* {
    yield _currentUser != null 
        ? AppAuthState(session: AppSession(user: _currentUser!)) 
        : AppAuthState(session: null);
    yield* _authController.stream;
  }

  // --- Helper for Data Conversion ---
  
  static Map<String, dynamic> _prepareForDb(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Map.from(json);
    data.forEach((key, value) {
      if (value is bool) {
        data[key] = value ? 1 : 0;
      } else if (value is Map || value is List) {
        data[key] = jsonEncode(value);
      }
    });
    return data;
  }
  
  static Map<String, dynamic> _parseFromDb(Map<String, dynamic> dbData) {
    final Map<String, dynamic> data = Map.from(dbData);
    data.forEach((key, value) {
      if (key.startsWith('is_') && value is int) { // heuristic for booleans
        data[key] = value == 1;
      } else if ((key == 'tags' || key == 'images' || key == 'facilities' || key == 'metadata' || key == 'timing_flexible' || key == 'item_details' || key == 'availability') && value is String) {
        try {
          data[key] = jsonDecode(value);
        } catch (e) {
          // keep as string if decode fails
        }
      }
    });
    return data;
  }

  // --- Profile Operations ---

  static Future<UserProfile?> getUserProfile() async {
    if (_currentUser == null) return null;
    final db = await _db;
    
    final List<Map<String, dynamic>> results = await db.query(
      'user_profiles',
      where: 'id = ?',
      whereArgs: [_currentUser!.id],
    );
    
    if (results.isEmpty) return null;
    return UserProfile.fromJson(_parseFromDb(results.first));
  }

  // --- Business Operations ---

  static Future<List<Business>> getBusinesses({String? category}) async {
    final db = await _db;
    List<Map<String, dynamic>> results;
    
    if (category != null) {
      results = await db.query('businesses', where: 'category = ?', whereArgs: [category]);
    } else {
      results = await db.query('businesses');
    }
    
    return results.map((data) => Business.fromJson(_parseFromDb(data))).toList();
  }

  static Future<Business?> getBusinessById(String id) async {
    final db = await _db;
    final List<Map<String, dynamic>> results = await db.query(
      'businesses',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (results.isEmpty) return null;
    return Business.fromJson(_parseFromDb(results.first));
  }

  // --- Product & Service Operations ---

  static Future<List<Product>> getProducts(String businessId) async {
    final db = await _db;
    final List<Map<String, dynamic>> results = await db.query(
      'products',
      where: 'business_id = ?',
      whereArgs: [businessId],
    );
    return results.map((data) => Product.fromJson(_parseFromDb(data))).toList();
  }

  static Future<List<Service>> getServices(String businessId) async {
    final db = await _db;
    final List<Map<String, dynamic>> results = await db.query(
      'services',
      where: 'business_id = ?',
      whereArgs: [businessId],
    );
    return results.map((data) => Service.fromJson(_parseFromDb(data))).toList();
  }

  // --- Booking Operations ---

  static Future<void> createBooking(Booking booking) async {
    final db = await _db;
    await db.insert('bookings', _prepareForDb(booking.toJson()));
  }

  static Future<List<Booking>> getUserBookings() async {
    if (_currentUser == null) return [];
    final db = await _db;
    
    final List<Map<String, dynamic>> results = await db.query(
      'bookings',
      where: 'user_id = ?',
      whereArgs: [_currentUser!.id],
      orderBy: 'created_at DESC',
    );
    
    return results.map((data) => Booking.fromJson(_parseFromDb(data))).toList();
  }

  static Future<List<Booking>> getBusinessBookings(String businessId) async {
    final db = await _db;
    
    final List<Map<String, dynamic>> results = await db.query(
      'bookings',
      where: 'business_id = ?',
      whereArgs: [businessId],
      orderBy: 'created_at DESC',
    );
    
    return results.map((data) => Booking.fromJson(_parseFromDb(data))).toList();
  }

  static Future<void> updateBookingStatus(String bookingId, String status) async {
    final db = await _db;
    await db.update(
      'bookings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  // --- Review Operations ---

  static Future<List<Review>> getBusinessReviews(String businessId) async {
    final db = await _db;
    
    final List<Map<String, dynamic>> results = await db.query(
      'reviews',
      where: 'business_id = ?',
      whereArgs: [businessId],
      orderBy: 'created_at DESC',
    );
    
    return results.map((data) => Review.fromJson(_parseFromDb(data))).toList();
  }

  static Future<void> addReview(Review review) async {
    final db = await _db;
    await db.insert('reviews', _prepareForDb(review.toJson()));
  }

  // --- Business Management Operations ---

  static Future<Business?> getBusinessForCurrentUser() async {
    if (_currentUser == null) return null;
    final db = await _db;

    try {
      // First try to get it from the admins table
      final admin = await getAdminProfile();
      if (admin != null && admin.businessId != null) {
        return await getBusinessById(admin.businessId!);
      }

      // Fallback to searching businesses by owner_id
      final List<Map<String, dynamic>> results = await db.query(
        'businesses',
        where: 'owner_id = ?',
        whereArgs: [_currentUser!.id],
      );
      
      if (results.isEmpty) return null;
      return Business.fromJson(_parseFromDb(results.first));
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateBusiness(Business business) async {
    final db = await _db;
    await db.update(
      'businesses',
      _prepareForDb(business.toJson()),
      where: 'id = ?',
      whereArgs: [business.id],
    );
  }

  // --- Product Management Operations ---

  static Future<void> addProduct(Product product) async {
    final db = await _db;
    await db.insert('products', _prepareForDb(product.toJson()));
  }

  static Future<void> updateProduct(Product product) async {
    final db = await _db;
    await db.update(
      'products',
      _prepareForDb(product.toJson()),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  static Future<void> deleteProduct(String productId) async {
    final db = await _db;
    await db.delete('products', where: 'id = ?', whereArgs: [productId]);
  }

  // --- Service Management Operations ---

  static Future<void> addService(Service service) async {
    final db = await _db;
    await db.insert('services', _prepareForDb(service.toJson()));
  }

  static Future<void> updateService(Service service) async {
    final db = await _db;
    await db.update(
      'services',
      _prepareForDb(service.toJson()),
      where: 'id = ?',
      whereArgs: [service.id],
    );
  }

  static Future<void> deleteService(String serviceId) async {
    final db = await _db;
    await db.delete('services', where: 'id = ?', whereArgs: [serviceId]);
  }

  // --- Admin/Management Operations ---

  static Future<void> createBusiness(Business business) async {
    final db = await _db;
    await db.insert('businesses', _prepareForDb(business.toJson()));
  }

  // --- Admin Specific Operations ---

  static Future<Admin?> getAdminProfile() async {
    if (_currentUser == null) return null;
    final db = await _db;

    final List<Map<String, dynamic>> results = await db.query(
      'admins',
      where: 'id = ?',
      whereArgs: [_currentUser!.id],
    );
    
    if (results.isEmpty) return null;
    return Admin.fromJson(_parseFromDb(results.first));
  }

  static Future<List<Admin>> getAllAdmins() async {
    final db = await _db;
    final List<Map<String, dynamic>> results = await db.query(
      'admins',
      orderBy: 'created_at DESC',
    );
    return results.map((data) => Admin.fromJson(_parseFromDb(data))).toList();
  }

  static Future<List<UserProfile>> getAllUsers() async {
    final db = await _db;
    final List<Map<String, dynamic>> results = await db.query(
      'user_profiles',
      orderBy: 'created_at DESC',
    );
    return results.map((data) => UserProfile.fromJson(_parseFromDb(data))).toList();
  }

  static Future<void> updateAdminStatus(String adminId, bool isApproved) async {
    final db = await _db;
    await db.update(
      'admins',
      {'is_approved': isApproved ? 1 : 0},
      where: 'id = ?',
      whereArgs: [adminId],
    );
  }

  static Future<void> deleteAdmin(String adminId) async {
    final db = await _db;
    await db.delete('admins', where: 'id = ?', whereArgs: [adminId]);
  }

  static Future<List<Business>> getAllBusinesses() async {
    final db = await _db;
    final List<Map<String, dynamic>> results = await db.query(
      'businesses',
      orderBy: 'name',
    );
    return results.map((data) => Business.fromJson(_parseFromDb(data))).toList();
  }

  static Future<List<Booking>> getAllBookings() async {
    final db = await _db;
    final List<Map<String, dynamic>> results = await db.query(
      'bookings',
      orderBy: 'created_at DESC',
    );
    return results.map((data) => Booking.fromJson(_parseFromDb(data))).toList();
  }

  static Future<void> deleteBusiness(String businessId) async {
    final db = await _db;
    await db.delete('businesses', where: 'id = ?', whereArgs: [businessId]);
  }

  // --- Admin Panel API Stubs (Web Admin) ---

  static Future<void> updateBusinessVerificationStatus(String businessId, bool isVerified) async {
    final db = await _db;
    await db.update(
      'businesses',
      {'is_verified': isVerified ? 1 : 0},
      where: 'id = ?',
      whereArgs: [businessId],
    );
  }

  static Future<void> updateBusinessActiveStatus(String businessId, bool isActive) async {
    final db = await _db;
    await db.update(
      'businesses',
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [businessId],
    );
  }

  static Future<void> updateUserBlockStatus(String userId, bool isBlocked) async {
    final db = await _db;
    await db.update(
      'user_profiles',
      {'is_blocked': isBlocked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> deleteReview(String reviewId) async {
    final db = await _db;
    await db.delete('reviews', where: 'id = ?', whereArgs: [reviewId]);
  }

  static Future<void> flagReview(String reviewId, bool isFlagged) async {
    final db = await _db;
    await db.update(
      'reviews',
      {'is_flagged': isFlagged ? 1 : 0},
      where: 'id = ?',
      whereArgs: [reviewId],
    );
  }

  static Future<Map<String, dynamic>> getDashboardStats() async {
    final db = await _db;
    final users = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM user_profiles')) ?? 0;
    final shops = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM businesses')) ?? 0;
    // final bookings = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM bookings')) ?? 0;
    
    return {
      'total_users': users,
      'total_shops': shops,
      'total_hospitals': 0, // Mocked for now
      'active_listings': shops, // simplified
    };
  }

  // --- Shop Owner Specific Methods ---

  static Future<Map<String, dynamic>> getOwnerDashboardStats(String shopId) async {
    final db = await _db;
    
    // Total Views (assuming we don't track views per day in this simple schema, mocking 'today' logic or using random if not tracked)
    // For this offline app, we might not have a views table. We can just return '0' or use a metadata field if we had one.
    // Let's assume 'review_count' equates to something engaged. But request asks for 'views'. 
    // We will just return 0 for views as we don't have a views table in schema.
    
    final wishlist = 0; // No wishlist table in schema
    
    final ordersCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM bookings WHERE business_id = ?', 
      [shopId]
    ));
    
    final activeOffers = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM offers WHERE business_id = ? AND is_active = 1', 
      [shopId]
    ));

    final businessData = await db.query('businesses', where: 'id = ?', whereArgs: [shopId]);
    double rating = 0.0;
    int reviewCount = 0;
    if (businessData.isNotEmpty) {
      rating = businessData.first['rating'] as double? ?? 0.0;
      reviewCount = businessData.first['review_count'] as int? ?? 0;
    }

    // Revenue calculation
    final result = await db.rawQuery(
      'SELECT SUM(total_price) as total FROM bookings WHERE business_id = ? AND status = ?',
      [shopId, 'completed']
    );
    double revenue = 0.0;
    if (result.isNotEmpty && result.first['total'] != null) {
      revenue = (result.first['total'] as num).toDouble();
    }

    return {
      'views': 0, // Not tracked in DB
      'today_views': 0, // Not tracked
      'wishlist': wishlist,
      'orders': ordersCount ?? 0,
      'active_offers': activeOffers ?? 0,
      'rating': rating,
      'review_count': reviewCount,
      'revenue': revenue,
      'weekly_views': [0, 0, 0, 0, 0, 0, 0], // Mock for chart
      'weekly_revenue': [0, 0, 0, 0, 0, 0, 0], // Mock for chart (would require complex date grouping)
    };
  }

  static Future<List<Map<String, dynamic>>> getShopOffers(String shopId) async {
    final db = await _db;
    final List<Map<String, dynamic>> results = await db.query(
      'offers',
      where: 'business_id = ?',
      whereArgs: [shopId],
    );
    return results.map((data) => _parseFromDb(data)).toList();
  }

  static Future<void> createOffer(Map<String, dynamic> offerData) async {
    final db = await _db;
    await db.insert('offers', _prepareForDb(offerData));
  }

  static Future<void> updateOfferStatus(String offerId, bool isActive) async {
    final db = await _db;
    await db.update(
      'offers',
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [offerId],
    );
  }

  static Future<void> updateShopImages(String shopId, List<String> imageUrls) async {
    final db = await _db;
    await db.update(
      'businesses',
      {'images': jsonEncode(imageUrls)},
      where: 'id = ?',
      whereArgs: [shopId],
    );
  }

  static Future<void> updateShopTiming(String shopId, Map<String, dynamic> timing) async {
    final db = await _db;
    await db.update(
      'businesses',
      {'timing_flexible': jsonEncode(timing)},
      where: 'id = ?',
      whereArgs: [shopId],
    );
  }

  // --- ADMIN PANEL METHODS ---

  static Future<Map<String, int>> getAdminDashboardStats() async {
    final db = await _db;
    final userCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM user_profiles'));
    final shopCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM businesses'));
    final productCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM products'));
    final serviceCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM services'));
    final hospitalCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM hospitals'));
    final activeListings = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM businesses WHERE is_active = 1'));
    
    return {
      'users': userCount ?? 0,
      'shops': shopCount ?? 0,
      'items': (productCount ?? 0) + (serviceCount ?? 0),
      'hospitals': hospitalCount ?? 0,
      'active_listings': activeListings ?? 0,
      'inactive_listings': (shopCount ?? 0) - (activeListings ?? 0),
    };
  }

  static Future<List<Map<String, dynamic>>> getAdminAllUsers() async {
    final db = await _db;
    return await db.query('user_profiles');
  }

  static Future<void> toggleUserBlock(String userId, bool isBlocked) async {
    final db = await _db;
    await db.update('user_profiles', {'is_blocked': isBlocked ? 1 : 0}, where: 'id = ?', whereArgs: [userId]);
  }

  static Future<void> deleteUser(String userId) async {
    final db = await _db;
    await db.delete('user_profiles', where: 'id = ?', whereArgs: [userId]);
  }

  static Future<List<Hospital>> getAllHospitals() async {
    final db = await _db;
    final results = await db.query('hospitals');
    return results.map((e) => Hospital.fromJson(_parseFromDb(e))).toList();
  }

  static Future<void> addHospital(Hospital hospital) async {
    final db = await _db;
    await db.insert('hospitals', _prepareForDb(hospital.toJson()));
  }

  static Future<void> toggleHospitalStatus(String id, bool isActive) async {
    final db = await _db;
    await db.update('hospitals', {'is_active': isActive ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Doctor>> getDoctors(String hospitalId) async {
    final db = await _db;
    final results = await db.query('doctors', where: 'hospital_id = ?', whereArgs: [hospitalId]);
    return results.map((e) => Doctor.fromJson(_parseFromDb(e))).toList();
  }

  static Future<void> addDoctor(Doctor doctor) async {
    final db = await _db;
    await db.insert('doctors', _prepareForDb(doctor.toJson()));
  }

  static Future<void> deleteDoctor(String doctorId) async {
    final db = await _db;
    await db.delete('doctors', where: 'id = ?', whereArgs: [doctorId]);
  }

  static Future<List<Map<String, dynamic>>> getAllReviewsAdmin() async {
    final db = await _db;
    return await db.query('reviews');
  }


  // --- Category Management ---

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await _db;
    return await db.query('categories', orderBy: 'name');
  }

  static Future<void> addCategory(String name, String icon) async {
    final db = await _db;
    await db.insert('categories', {
      'id': _uuid.v4(),
      'name': name,
      'icon': icon,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> deleteCategory(String id) async {
    final db = await _db;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // --- Admin Settings ---

  static Future<void> updateAdminPassword(String email, String newPassword) async {
    final db = await _db;
    await db.update(
      'auth_users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}

