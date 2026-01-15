import 'package:flutter/material.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/services/supabase_service.dart';

class OwnerProfileScreen extends StatelessWidget {
  final Business business;
  const OwnerProfileScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF2962FF)]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Row(
                children: [
                   CircleAvatar(
                     radius: 35,
                     backgroundColor: Colors.white24,
                     child: Text(business.name[0], style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                   ),
                   const SizedBox(width: 20),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(business.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                         const Text('Store ID: #821039', style: TextStyle(color: Colors.white70, fontSize: 13)),
                       ],
                     ),
                   ),
                   IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () => SupabaseService.signOut()),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildVerificationBanner(),
                  const SizedBox(height: 25),
                  _buildSection('Account Settings', [
                    _SettingsItem(title: 'Notification Settings', icon: Icons.notifications_none, onTap: () {}),
                    _SettingsItem(title: 'Privacy & Security', icon: Icons.security, onTap: () {}),
                    _SettingsItem(title: 'Payment Methods', icon: Icons.payment, onTap: () {}),
                  ]),
                  const SizedBox(height: 20),
                  _buildSection('Support', [
                    _SettingsItem(title: 'Help Center', icon: Icons.help_outline, onTap: () {}),
                    _SettingsItem(title: 'Contact Support', icon: Icons.headset_mic_outlined, onTap: () {}),
                    _SettingsItem(title: 'App Feedback', icon: Icons.feedback_outlined, onTap: () {}),
                  ]),
                  const SizedBox(height: 30),
                  const Text('App Version 1.0.4', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green[100]!)),
      child: Row(
        children: [
          const Icon(Icons.verified, color: Colors.green),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Business Verified', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                Text('Your business is fully verified and listed on Town Seek.', style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _SettingsItem({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle), child: Icon(icon, color: Colors.blue, size: 20)),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
    );
  }
}

