import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:town_seek/screens/admin/admin_login_screen.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/screens/admin/users/manage_users_screen.dart';
import 'package:town_seek/screens/admin/shops/manage_shops_screen.dart';
import 'package:town_seek/screens/admin/hospitals/manage_hospitals_screen.dart';
import 'package:town_seek/screens/admin/settings/admin_settings_screen.dart';

class MainAdminDashboard extends StatefulWidget {
  const MainAdminDashboard({super.key});

  @override
  State<MainAdminDashboard> createState() => _MainAdminDashboardState();
}

class _MainAdminDashboardState extends State<MainAdminDashboard> {
  bool _isLoading = true;
  Map<String, int> _stats = {
    'users': 0,
    'shops': 0,
    'items': 0,
    'hospitals': 0,
    'active_listings': 0,
    'inactive_listings': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final stats = await SupabaseService.getAdminDashboardStats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all session data
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Master Admin Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2962FF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome back, ',
                          style: TextStyle(color: Colors.black87, fontSize: 20),
                        ),
                        TextSpan(
                          text: 'Admin',
                          style: TextStyle(
                            color: Color(0xFF2962FF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStatsGrid(),
                  const SizedBox(height: 30),
                  const Text(
                    'Management Modules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuGrid(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard('Total Users', _stats['users'].toString(), Icons.people, Colors.blue),
        _buildStatCard('Total Shops', _stats['shops'].toString(), Icons.store, Colors.orange),
        _buildStatCard('Products/Services', _stats['items'].toString(), Icons.inventory_2, Colors.purple),
        _buildStatCard('Total Hospitals', _stats['hospitals'].toString(), Icons.local_hospital, Colors.red),
        _buildStatCard('Active Listings', _stats['active_listings'].toString(), Icons.check_circle, Colors.green),
        _buildStatCard('Inactive Listings', _stats['inactive_listings'].toString(), Icons.block, Colors.grey),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.9,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMenuCard(
          'Users',
          Icons.people_outline,
          Colors.blue,
          () {
             Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageUsersScreen()));
          },
        ),
        _buildMenuCard(
          'Shops',
          Icons.storefront_outlined,
          Colors.orange,
          () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageShopsScreen()));
          },
        ),
        _buildMenuCard(
          'Items',
          Icons.shopping_bag_outlined,
          Colors.purple,
          () {},
        ),
        _buildMenuCard(
          'Hospitals',
          Icons.local_hospital_outlined,
          Colors.red,
          () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageHospitalsScreen()));
          },
        ),
        _buildMenuCard(
          'Reviews',
          Icons.star_outline,
          Colors.amber,
          () {},
        ),
        _buildMenuCard(
          'Offers',
          Icons.local_offer_outlined,
          Colors.pink,
          () {},
        ),
        _buildMenuCard(
          'Categories',
          Icons.category_outlined,
          Colors.teal,
          () {},
        ),
        _buildMenuCard(
          'Settings',
          Icons.settings_outlined,
          Colors.grey,
          () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const AdminSettingsScreen()));
          },
        ),
      ],
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
