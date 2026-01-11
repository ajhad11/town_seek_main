import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Admin Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView(
              children: [
                _buildSettingsSection('App Configuration', [
                  _SettingsTile(
                    title: 'Service Categories',
                    subtitle: 'Manage main categories for discovery',
                    icon: Icons.category,
                  ),
                  _SettingsTile(
                    title: 'App Information',
                    subtitle: 'Update app version, links, and text',
                    icon: Icons.info_outline,
                  ),
                  _SettingsTile(
                    title: 'Maintenance Mode',
                    subtitle: 'Enable/Disable app access',
                    icon: Icons.build,
                    isSwitch: true,
                  ),
                ]),
                const SizedBox(height: 25),
                _buildSettingsSection('Policies & Legal', [
                  _SettingsTile(
                    title: 'Privacy Policy',
                    subtitle: 'Last updated: 12 Dev 2023',
                    icon: Icons.privacy_tip_outlined,
                  ),
                  _SettingsTile(
                    title: 'Terms of Service',
                    subtitle: 'Standard terms for users and businesses',
                    icon: Icons.description_outlined,
                  ),
                ]),
                const SizedBox(height: 25),
                _buildSettingsSection('Admin Management', [
                  _SettingsTile(
                    title: 'Security Settings',
                    subtitle: 'Passwords, 2FA, and sessions',
                    icon: Icons.security,
                  ),
                  _SettingsTile(
                    title: 'Admin Roles',
                    subtitle: 'Assign permissions to other admins',
                    icon: Icons.admin_panel_settings_outlined,
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSwitch;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isSwitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2962FF).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF2962FF), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: isSwitch
          ? Switch(value: false, onChanged: (v) {})
          : const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
