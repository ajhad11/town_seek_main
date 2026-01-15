import 'package:flutter/material.dart';
import 'package:town_seek/data/wishlist_manager.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/widgets/shop_card.dart';
import 'package:town_seek/screens/services/shop_page.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Business> _items = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  void _loadWishlist() {
    setState(() {
      _items = WishlistManager().wishlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: const Color(0xFF2962FF),
      ),
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                   const SizedBox(height: 20),
                   const Text("Your wishlist is empty", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final business = _items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShopPage(business: business)),
                      );
                      _loadWishlist(); // Refresh when coming back
                    },
                    child: ShopCard(
                      imageUrl: business.imageUrl ?? '',
                      title: business.name,
                      subtitle: business.category ?? 'Local Business',
                      rating: business.rating.toString(),
                      tags: business.tags,
                      isOpen: business.isOpen,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

