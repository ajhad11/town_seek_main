/// Home Screen for Town Seek App
///
/// This file contains the main home screen implementation for the Town Seek application,
/// a local services and shopping discovery app. The screen displays various sections
/// including location header, service categories, promotional banners, nearby shops,
/// and bottom navigation.
///
/// Features:
/// - Scrollable content with multiple sections
/// - Interactive bottom navigation (currently visual only)
/// - Network image loading with error handling
/// - Responsive design with proper spacing and shadows
/// - Custom UI components for consistent branding
library;

import 'package:flutter/material.dart';
import 'package:town_seek/screens/services/groceries_page.dart';
import 'package:town_seek/widgets/custom_header.dart';
import 'package:town_seek/widgets/shop_card.dart';

import '../services/food_page.dart';
import '../services/fashion_page.dart';
import '../services/health_page.dart';
import '../services/services_page.dart';
import '../services/shop_page.dart';



/// Main Home Screen Widget
///
/// This is the primary screen of the Town Seek app, displaying a scrollable
/// interface with various sections for local service discovery.


// ... (imports)

import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/models/business.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const CustomHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  SizedBox(height: 20),
                  CategoriesSection(),
                  SizedBox(height: 20),
                  PromoBanner(),
                  SizedBox(height: 20),
                  NearbyShopsList(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Categories Section
// ---------------------------------------------------------------------------
class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  final List<Map<String, dynamic>> _categories = const <Map<String, dynamic>>[
    {'name': 'Groceries', 'icon': Icons.shopping_basket, 'iconColor': Colors.orange},
    {'name': 'Food', 'icon': Icons.fastfood, 'iconColor': Colors.green},
    {'name': 'Fashion', 'icon': Icons.shopping_bag, 'iconColor': Colors.purple},
    {'name': 'Health', 'icon': Icons.medical_services, 'iconColor': Colors.blue},
    {'name': 'Services', 'icon': Icons.handyman, 'iconColor': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ActionChip(
              avatar: Icon(cat['icon']! as IconData, color: cat['iconColor']! as Color, size: 18),
              label: Text(cat['name']! as String),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey[200]!)),
              onPressed: () {
                switch (cat['name'] as String) {
                  case 'Groceries':
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GroceriesPage()));
                    break;
                  case 'Food':
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodPage()));
                    break;
                  case 'Fashion':
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FashionPage()));
                    break;
                  case 'Health':
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthPage()));
                    break;
                  case 'Services':
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ServicesPage()));
                    break;
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFF2962FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("50% Off Summer\nSale",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 8),
                  const Text("At Shop Name", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.access_time, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text("4 Days Left", style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Positioned(
              right: 20,
              bottom: 10,
              child: SizedBox(
                width: 100,
                height: 120,
                child: Icon(Icons.shopping_bag, size: 80, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NearbyShopsList extends StatelessWidget {
  const NearbyShopsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nearby Shops',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        FutureBuilder<List<Business>>(
          future: SupabaseService.getBusinesses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            
            final businesses = snapshot.data ?? [];
            if (businesses.isEmpty) {
              return const Center(child: Text('No shops found near you.'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: businesses.map<Widget>((Business business) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopPage(business: business),
                          ),
                        );
                      },
                      child: ShopCard(
                        imageUrl: business.imageUrl ?? '',
                        title: business.name,
                        subtitle: business.category ?? 'Local Business',
                        rating: business.rating.toString(),
                        tags: business.tags,
                        isOpen: business.isOpen,
                        distance: "1.2 km", // Placeholder for actual distance
                        hasParking: business.facilities?['parking'] ?? true,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}




