import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/screens/services/shop_page.dart';
import 'package:town_seek/utils/ui_utils.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  GoogleMapController? _mapController;
  final ScrollController _scrollController = ScrollController();
  
  List<Business> _businesses = [];
  bool _isLoading = true;
  String? _selectedBusinessId;
  Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(9.9312, 76.2673),
    zoom: 13.0,
  );

  @override
  void initState() {
    super.initState();
    _loadBusinesses();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadBusinesses() async {
    try {
      final businesses = await SupabaseService.getBusinesses();
      setState(() {
        _businesses = businesses;
        _isLoading = false;
        _createMarkers();
      });
    } catch (e) {
      if (mounted) {
        UIUtils.showPopup(context, 'Failed to load businesses on map: $e', isError: true);
      }
      setState(() => _isLoading = false);
    }
  }

  void _createMarkers() {
    final markers = _businesses.where((b) => b.latitude != null && b.longitude != null).map((business) {
      return Marker(
        markerId: MarkerId(business.id),
        position: LatLng(business.latitude!, business.longitude!),
        infoWindow: InfoWindow(title: business.name, snippet: business.category),
        onTap: () {
          final index = _businesses.indexOf(business);
          if (index != -1) _onMarkerTapped(business, index);
        },
      );
    }).toSet();
    setState(() {
      _markers = markers;
    });
  }

  void _onMarkerTapped(Business business, int index) {
    setState(() {
      _selectedBusinessId = business.id;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(business.latitude!, business.longitude!),
        15.0,
      ),
    );

    if (_scrollController.hasClients) {
      final position = index * 266.0;
      _scrollController.animateTo(
        position, 
        duration: const Duration(milliseconds: 500), 
        curve: Curves.easeOutCubic
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Town', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF2962FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadBusinesses();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (_) => setState(() => _selectedBusinessId = null),
          ),
          
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          
          // Bottom Carousel of shops
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            height: 140,
            child: _businesses.isEmpty 
              ? const SizedBox.shrink()
              : ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: _businesses.length,
                  itemBuilder: (context, index) {
                    final business = _businesses[index];
                    final isSelected = _selectedBusinessId == business.id;

                    return GestureDetector(
                      onTap: () => _onMarkerTapped(business, index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 250,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: isSelected 
                            ? Border.all(color: const Color(0xFF2962FF), width: 2) 
                            : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                              child: business.imageUrl != null 
                                ? Image.network(business.imageUrl!, width: 90, height: double.infinity, fit: BoxFit.cover)
                                : Container(width: 90, color: Colors.grey[200], child: const Icon(Icons.store)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      business.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      business.category ?? 'Local Business',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ShopPage(business: business),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2962FF),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                        minimumSize: const Size(0, 30),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text('View Detail', style: TextStyle(fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
