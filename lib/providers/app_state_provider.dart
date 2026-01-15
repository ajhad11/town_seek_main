import 'dart:async';
import 'package:flutter/material.dart';
import 'package:town_seek/models/app_role.dart';
import 'package:town_seek/models/user_profile.dart';
import 'package:town_seek/services/supabase_service.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  AppRole? get userRole => _userProfile?.role;

  StreamSubscription? _authSubscription;

  AppStateProvider() {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    _authSubscription = SupabaseService.authStateChanges.listen((data) {
      final session = data.session;
      if (session != null) {
        _loadUserProfile();
      } else {
        _userProfile = null;
        _isLoading = false;
        notifyListeners();
      }
    });

    // Also check initial state
    if (SupabaseService.currentUser != null) {
      _loadUserProfile();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      _isLoading = true;
      notifyListeners();

      final profile = await SupabaseService.getUserProfile();
      final adminProfile = await SupabaseService.getAdminProfile();
      
      if (profile != null) {
        _userProfile = profile;
        // If they are in the admins table, override the role
        if (adminProfile != null) {
          _userProfile = _userProfile!.copyWith(role: adminProfile.role);
        }
      } else {
        // Fallback: If DB entry is missing but Auth is valid
        final currentUser = SupabaseService.currentUser;
        if (currentUser != null) {
          _userProfile = UserProfile(
            id: currentUser.id,
            email: currentUser.email,
            role: adminProfile?.role ?? AppRole.user, 
            createdAt: DateTime.now(),
          );
        } else {
          _userProfile = null;
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      // Even on error, if we have a session, try to stay logged in as User
      final currentUser = SupabaseService.currentUser;
      if (currentUser != null) {
          _userProfile = UserProfile(
            id: currentUser.id,
            email: currentUser.email,
            role: AppRole.user,
            createdAt: DateTime.now(),
          );
      } else {
        _userProfile = null;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

