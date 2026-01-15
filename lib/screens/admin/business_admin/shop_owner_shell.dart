import 'package:flutter/material.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/screens/admin/business_admin/owner_dashboard_screen.dart';
import 'package:town_seek/screens/admin/business_admin/shop_profile_screen.dart';
import 'package:town_seek/screens/admin/business_admin/inventory_management_screen.dart';
import 'package:town_seek/screens/admin/business_admin/order_booking_management_screen.dart';
import 'package:town_seek/screens/admin/business_admin/owner_profile_screen.dart';
import 'package:town_seek/screens/admin/business_admin/offer_management_screen.dart';
import 'package:town_seek/screens/admin/business_admin/owner_review_screen.dart';
import 'package:town_seek/screens/admin/business_admin/shop_qr_code_screen.dart';

class ShopOwnerShell extends StatefulWidget {
  final Business business;
  const ShopOwnerShell({super.key, required this.business});

  @override
  State<ShopOwnerShell> createState() => _ShopOwnerShellState();
}

class _ShopOwnerShellState extends State<ShopOwnerShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      OwnerDashboardScreen(shopId: widget.business.id),
      InventoryManagementScreen(business: widget.business),
      OrderBookingManagementScreen(shopId: widget.business.id),
      OwnerProfileScreen(business: widget.business),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2962FF),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Insights'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Inventory'),
            BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined), activeIcon: Icon(Icons.event_note), label: 'Bookings'),
            BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: 'Store'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF2962FF)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Text(widget.business.name[0], style: const TextStyle(color: Colors.white, fontSize: 24))),
                   const SizedBox(height: 10),
                   Text(widget.business.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                   Text(widget.business.category ?? 'Business Account', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            _DrawerTile(icon: Icons.edit_note, title: 'Shop Profile', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShopProfileManagementScreen(business: widget.business)));
            }),
            _DrawerTile(icon: Icons.local_offer_outlined, title: 'Offers & Promos', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OfferManagementScreen(shopId: widget.business.id)));
            }),
            _DrawerTile(icon: Icons.star_outline, title: 'Reviews', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerReviewScreen(shopId: widget.business.id)));
            }),
            _DrawerTile(icon: Icons.qr_code_2, title: 'Shop QR Code', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShopQRCodeScreen(business: widget.business)));
            }),
            const Divider(),
            _DrawerTile(icon: Icons.logout, title: 'Logout', onTap: () => SupabaseService.signOut()),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _DrawerTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

