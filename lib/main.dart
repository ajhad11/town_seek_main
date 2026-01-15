import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';

import 'package:town_seek/screens/auth/login_screen.dart';
import 'package:town_seek/screens/auth/account_type_screen.dart';
import 'package:town_seek/screens/auth/signup_screen.dart';
import 'package:town_seek/screens/main/main_screen.dart';
import 'package:town_seek/screens/admin/super_admin/screens/super_admin_dashboard.dart';
import 'package:town_seek/screens/admin/business_admin/business_registration_screen.dart';
import 'package:town_seek/screens/admin/business_admin/shop_owner_shell.dart'; // Import New Owner Panel
import 'package:town_seek/screens/splash/splash_screen.dart';

import 'package:town_seek/screens/admin/common/admin_login_screen.dart';
import 'package:town_seek/screens/admin/super_admin/screens/main_admin_dashboard.dart';
import 'package:town_seek/screens/admin/common/access_denied_screen.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:town_seek/utils/permission_manager.dart';
// import 'package:town_seek/utils/supabase_constants.dart';
import 'package:town_seek/providers/auth_provider.dart';
import 'package:town_seek/models/app_role.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/models/business.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase initialization removed for local DB migration
  // Initialize sqflite for Windows/Linux
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF2962FF), // App Blue Theme
    statusBarIconBrightness: Brightness.light, // White icons
    statusBarBrightness: Brightness.dark, // For iOS
  ));

  // Request permissions on startup
  await PermissionManager.requestInitialPermissions();
  
  // Restore session if any
  await SupabaseService.restoreSession();

  runApp(
    const ProviderScope(
      child: TownSeekApp(),
    ),
  );
}

class TownSeekApp extends StatelessWidget {
  const TownSeekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TownSeek',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.dmSansTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2962FF),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF2962FF),
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/auth': (context) => const AuthGate(),
        '/account_type': (context) => const AccountTypeScreen(),
        '/login': (context) => const LoginScreen(),
        '/sign_in': (context) => const SignUpScreen(),
        '/main': (context) => const MainScreen(), 
        '/super-admin-dashboard': (context) => const SuperAdminDashboard(),
        '/admin-login': (context) => const AdminLoginScreen(),
        '/admin-dashboard': (context) => const MainAdminDashboard(),
        '/access-denied': (context) => const AccessDeniedScreen(),
      },
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return userProfileAsync.when(
      data: (user) {
        if (user == null) {
          return const AccountTypeScreen();
        }

        switch (user.role) {
          case AppRole.superAdmin:
            if (kIsWeb) return const MainAdminDashboard();
            return const SuperAdminDashboard();
          case AppRole.businessAdmin:
            return FutureBuilder<Business?>(
              future: SupabaseService.getBusinessForCurrentUser(),
              builder: (context, AsyncSnapshot<Business?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                final business = snapshot.data;
                if (business == null) return const BusinessRegistrationScreen(); // Fallback to register screen
                return ShopOwnerShell(business: business);
              },
            );
          case AppRole.user:
            if (kIsWeb && Uri.base.path.contains('admin')) return const AccessDeniedScreen();
            return const MainScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

