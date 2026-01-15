import 'package:flutter/foundation.dart';
import '../models/business.dart';

class WishlistManager extends ChangeNotifier {
  static final WishlistManager _instance = WishlistManager._internal();
  
  factory WishlistManager() {
    return _instance;
  }

  WishlistManager._internal();

  final Set<String> _wishlistIds = {};
  final List<Business> _cachedBusinesses = [];

  bool isWishlisted(String id) {
    return _wishlistIds.contains(id);
  }

  void toggleWishlist(Business business) {
    if (_wishlistIds.contains(business.id)) {
      _wishlistIds.remove(business.id);
      _cachedBusinesses.removeWhere((b) => b.id == business.id);
    } else {
      _wishlistIds.add(business.id);
      _cachedBusinesses.add(business);
    }
    notifyListeners();
  }

  void addToWishlist(Business business) {
    if (!_wishlistIds.contains(business.id)) {
      _wishlistIds.add(business.id);
      _cachedBusinesses.add(business);
      notifyListeners();
    }
  }

  void removeFromWishlist(Business business) {
    if (_wishlistIds.contains(business.id)) {
      _wishlistIds.remove(business.id);
      _cachedBusinesses.removeWhere((b) => b.id == business.id);
      notifyListeners();
    }
  }

  List<Business> get wishlistBusinesses => _cachedBusinesses;
  List<Business> get wishlist => _cachedBusinesses;
}

