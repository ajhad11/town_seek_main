import 'package:flutter/material.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'main_admin_panel.dart';

class MainAdminAuthGuard extends StatefulWidget {
  const MainAdminAuthGuard({super.key});

  @override
  State<MainAdminAuthGuard> createState() => _MainAdminAuthGuardState();
}

class _MainAdminAuthGuardState extends State<MainAdminAuthGuard> {
  static const String superAdminEmail = 'ajhadk453@gmail.com';
  bool _isChecking = true;
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();
    _checkAuthorization();
  }

  Future<void> _checkAuthorization() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final user = SupabaseService.currentUser;

    setState(() {
      _isChecking = false;
      _isAuthorized = user?.email == superAdminEmail;
    });

    if (!_isAuthorized && user != null) {
      await SupabaseService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Verifying admin credentials...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    if (!_isAuthorized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Access Denied',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Super Admin Only\n\nYou are not authorized to access this panel.\n\nAuthorized Email: $superAdminEmail',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const MainAdminPanel();
  }
}
