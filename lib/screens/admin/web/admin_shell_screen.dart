import 'package:flutter/material.dart';
import 'package:town_seek/screens/admin/web/widgets/admin_sidebar.dart';
import 'package:town_seek/screens/admin/web/widgets/admin_top_bar.dart';
import 'package:town_seek/screens/admin/web/admin_dashboard_screen.dart';
import 'package:town_seek/screens/admin/web/user_management_screen.dart';
import 'package:town_seek/screens/admin/web/shop_management_screen.dart';
import 'package:town_seek/screens/admin/web/hospital_management_screen.dart';
import 'package:town_seek/screens/admin/web/review_moderation_screen.dart';
import 'package:town_seek/screens/admin/web/promotion_screen.dart';
import 'package:town_seek/screens/admin/web/admin_settings_screen.dart';

class AdminShellScreen extends StatefulWidget {
  const AdminShellScreen({super.key});

  @override
  State<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends State<AdminShellScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    AdminDashboardScreen(),
    UserManagementScreen(),
    ShopManagementScreen(),
    HospitalManagementScreen(),
    ReviewModerationScreen(),
    PromotionScreen(),
    AdminSettingsScreen(),
  ];

  final List<String> _titles = const [
    'Dashboard',
    'User Management',
    'Shop Management',
    'Hospital & Services',
    'Review Moderation',
    'Promotions',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Column(
              children: [
                AdminTopBar(title: _titles[_selectedIndex]),
                Expanded(
                  child: _screens[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
