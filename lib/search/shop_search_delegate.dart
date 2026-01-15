import 'package:flutter/material.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/screens/services/shop_page.dart';
import 'package:town_seek/widgets/shop_card.dart';

class ShopSearchDelegate extends SearchDelegate {
  final List<Business>? searchScope;

  ShopSearchDelegate({this.searchScope});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.grey),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    return FutureBuilder<List<Business>>(
      future: searchScope != null ? Future.value(searchScope) : SupabaseService.getBusinesses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && query.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final allBusinesses = snapshot.data ?? [];
        final results = allBusinesses.where((business) {
          final lowerQuery = query.toLowerCase();
          final lowerName = business.name.toLowerCase();
          final lowerCategory = (business.category ?? '').toLowerCase();
          final lowerAddress = (business.address ?? '').toLowerCase();
          
          bool nameMatches = lowerName.contains(lowerQuery);
          bool tagsMatch = business.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
          bool categoryMatches = lowerCategory.contains(lowerQuery);
          bool addressMatches = lowerAddress.contains(lowerQuery);

          return nameMatches || tagsMatch || categoryMatches || addressMatches;
        }).toList();

        if (results.isEmpty && snapshot.connectionState == ConnectionState.done) {
          return const Center(
            child: Text("No results found.", style: TextStyle(color: Colors.grey, fontSize: 16)),
          );
        }

        return Container(
          color: const Color(0xFFF5F5F5),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final business = results[index];
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
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

