import 'package:flutter/material.dart';
import 'package:town_seek/services/database_helper.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/screens/admin/common/admin_login_screen.dart';
import 'package:town_seek/screens/admin/super_admin/modules/settings/manage_categories_screen.dart'; // Ensure this matches path
import 'package:shared_preferences/shared_preferences.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final String _adminEmail = 'ajhadk453@gmail.com'; // Hardcoded as per requirement

  Future<void> _changePassword() async {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Admin Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
            TextField(controller: confirmCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (passCtrl.text == confirmCtrl.text && passCtrl.text.isNotEmpty) {
                await SupabaseService.updateAdminPassword(_adminEmail, passCtrl.text);
                
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated successfully')));
                }
              } else {
                 if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Database'),
        content: const Text('WARNING: This will delete ALL data (Users, Shops, etc). This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('RESET')),
        ],
      ),
    );

    if (confirm == true) {
      final db = await DatabaseHelper.instance.database;
      final tables = ['user_profiles', 'businesses', 'products', 'services', 'bookings', 'reviews', 'admins', 'offers', 'auth_users', 'hospitals', 'doctors', 'categories'];
      
      for (var table in tables) {
        await db.delete(table);
      }
      
      // Re-create admin user to avoid lockout, or force logout
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database cleared. Logging out...')));
        await _logout();
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => const AdminLoginScreen()), 
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   const CircleAvatar(radius: 40, backgroundColor: Colors.indigo, child: Icon(Icons.security, size: 40, color: Colors.white)),
                   const SizedBox(height: 15),
                   const Text('Master Admin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 5),
                   Text(_adminEmail, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                   const SizedBox(height: 15),
                   OutlinedButton.icon(
                     onPressed: _changePassword,
                     icon: const Icon(Icons.lock_reset),
                     label: const Text('Change Password'),
                   )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          ListTile(
            title: const Text('General Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.category, color: Colors.indigo),
                  title: const Text('Manage Categories'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageCategoriesScreen()));
                  },
                ),
                const Divider(),
                 ListTile(
                  leading: const Icon(Icons.app_settings_alt, color: Colors.indigo),
                  title: const Text('App Configuration'),
                  subtitle: const Text('App Name, Version'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Placeholder for App Config
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('App Name: Town Seek v1.0.0 (Offline)')));
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          
          ListTile(
            title: const Text('Danger Zone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
          ),
          Card(
            color: Colors.red.shade50,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Reset Database', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Delete all application data permanently'),
                  onTap: () => _resetDatabase(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}

