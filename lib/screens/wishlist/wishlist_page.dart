import 'package:flutter/material.dart';
import 'package:town_seek/data/wishlist_manager.dart';
import 'package:town_seek/screens/main/main_screen.dart';
import 'package:town_seek/screens/services/shop_page.dart';
import 'package:town_seek/search/shop_search_delegate.dart';
import 'package:town_seek/widgets/custom_header.dart';
import 'package:town_seek/widgets/shop_card.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/utils/ui_utils.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final List<String> _categories = ['All', 'Groceries', 'Food', 'Services', 'Fashion'];
  String _selectedCategory = 'All';

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _removeFromWishlist(Business business) {
    WishlistManager().removeFromWishlist(business);
    UIUtils.showPopup(context, "${business.name} removed from wishlist");
  }

  List<Business> _getFilteredBusinesses(List<Business> allWishlistBusinesses) {
    if (_selectedCategory == 'All') {
      return allWishlistBusinesses;
    }
    return allWishlistBusinesses.where((business) {
      return business.category == _selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomHeader(
            showBackButton: true, 
            title: "Wishlists",
            onBack: () {
              final mainScreen = context.findAncestorStateOfType<MainScreenState>();
              if (mainScreen != null) {
                mainScreen.goToTab(0);
              } else {
                Navigator.pop(context);
              }
            },
            onSearchTap: () {
               showSearch(
                 context: context,
                 delegate: ShopSearchDelegate(searchScope: WishlistManager().wishlistBusinesses),
               );
            },
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => _onCategoryTap(category),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF2962FF) : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected ? Colors.transparent : Colors.grey[300]!,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListenableBuilder(
                    listenable: WishlistManager(),
                    builder: (context, child) {
                      final allWishlistBusinesses = WishlistManager().wishlistBusinesses;
                      final displayBusinesses = _getFilteredBusinesses(allWishlistBusinesses);

                      if (displayBusinesses.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("No items in wishlist", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: displayBusinesses.length,
                          itemBuilder: (context, index) {
                            final business = displayBusinesses[index];
                            return _buildWishlistBusinessItem(business);
                          },
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistBusinessItem(Business business) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
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
              ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _removeFromWishlist(business),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "REMOVE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}