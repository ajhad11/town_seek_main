import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: MediaQuery.of(context).size.width > 1200,
      backgroundColor: const Color(0xFF1E1E2D),
      unselectedIconTheme: const IconThemeData(color: Colors.white54),
      selectedIconTheme: const IconThemeData(color: Colors.white),
      unselectedLabelTextStyle: const TextStyle(color: Colors.white54),
      selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      indicatorColor: const Color(0xFF2962FF),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people_alt_outlined),
          selectedIcon: Icon(Icons.people_alt),
          label: Text('Users'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: Text('Shops'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.local_hospital_outlined),
          selectedIcon: Icon(Icons.local_hospital),
          label: Text('Hospitals'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.rate_review_outlined),
          selectedIcon: Icon(Icons.rate_review),
          label: Text('Reviews'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.campaign_outlined),
          selectedIcon: Icon(Icons.campaign),
          label: Text('Promotions'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      leading: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset('assets/Logo.png', height: 40, errorBuilder: (c, e, s) => const Icon(Icons.location_on, color: Colors.blue, size: 40)),
          if (MediaQuery.of(context).size.width > 1200) ...[
            const SizedBox(height: 10),
            const Text(
              'TOWN SEEK',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            const Text(
              'ADMIN PANEL',
              style: TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
