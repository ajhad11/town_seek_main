import 'package:flutter/material.dart';
import 'package:town_seek/widgets/custom_header.dart';
import 'package:town_seek/widgets/shop_card.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/models/business.dart';
import 'shop_page.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final Set<String> _selectedFilters = {'All'};

  void _onFilterTap(String filter) {
    setState(() {
      if (filter == 'All') {
        _selectedFilters.clear();
        _selectedFilters.add('All');
      } else {
        _selectedFilters.remove('All');
        if (_selectedFilters.contains(filter)) {
          _selectedFilters.remove(filter);
        } else {
          _selectedFilters.add(filter);
        }
        if (_selectedFilters.isEmpty) {
          _selectedFilters.add('All');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(showBackButton: true),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All'),
                          const SizedBox(width: 10),
                          _buildFilterChip('Parking'),
                          const SizedBox(width: 10),
                          _buildFilterChip('Open'),
                          const SizedBox(width: 10),
                          _buildFilterChip('Nearby'),
                          const SizedBox(width: 10),
                          _buildFilterChip('Offer'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Professional Services',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    FutureBuilder<List<Business>>(
                      future: SupabaseService.getBusinesses(category: 'Services'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        
                        final businesses = snapshot.data ?? [];
                        if (businesses.isEmpty) {
                          return const Center(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("No service shops found"),
                          ));
                        }

                        return Column(
                          children: businesses.map((business) => Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
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
                                subtitle: business.category ?? 'Services',
                                rating: business.rating.toString(),
                                tags: business.tags,
                                isOpen: business.isOpen,
                              ),
                            ),
                          )).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String text) {
    final isSelected = _selectedFilters.contains(text);
    return GestureDetector(
      onTap: () => _onFilterTap(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2962FF) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[200]!),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
