import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:town_seek/models/user_profile.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/models/app_role.dart';

final authStateProvider = StreamProvider((ref) {
  return SupabaseService.authStateChanges;
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authState = ref.watch(authStateProvider).value;
  final session = authState?.session;
  
  if (session == null && SupabaseService.currentUser == null) return null;

  try {
    final profile = await SupabaseService.getUserProfile();
    final adminProfile = await SupabaseService.getAdminProfile();
    
    if (profile != null) {
      if (adminProfile != null) {
        return profile.copyWith(role: adminProfile.role);
      }
      return profile;
    } else {
      final currentUser = SupabaseService.currentUser;
      if (currentUser != null) {
        return UserProfile(
          id: currentUser.id,
          email: currentUser.email,
          role: adminProfile?.role ?? AppRole.user,
          createdAt: DateTime.now(),
        );
      }
    }
  } catch (e) {
    // Fallback on error if session exists
    final currentUser = SupabaseService.currentUser;
      if (currentUser != null) {
        return UserProfile(
          id: currentUser.id,
          email: currentUser.email,
          role: AppRole.user,
          createdAt: DateTime.now(),
        );
      }
  }
  return null;
});
