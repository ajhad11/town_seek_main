import 'package:flutter/material.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/services/supabase_service.dart';

class ManageShopsScreen extends StatefulWidget {
  const ManageShopsScreen({super.key});

  @override
  State<ManageShopsScreen> createState() => _ManageShopsScreenState();
}

class _ManageShopsScreenState extends State<ManageShopsScreen> {
  List<Business> _shops = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  Future<void> _loadShops() async {
    setState(() => _isLoading = true);
    try {
      final shops = await SupabaseService.getAllBusinesses();
      if (!mounted) return;
      setState(() {
        _shops = shops;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Shops', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _shops.isEmpty 
              ? const Center(child: Text('No shops found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _shops.length,
                  itemBuilder: (context, index) {
                    final shop = _shops[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: shop.imageUrl != null ? NetworkImage(shop.imageUrl!) : null,
                          backgroundColor: Colors.orange.shade100,
                          child: shop.imageUrl == null ? const Icon(Icons.store, color: Colors.orange) : null,
                        ),
                        title: Text(shop.name),
                        subtitle: Text(shop.address ?? 'No address'),
                        trailing: Switch(
                          value: shop.isOpen,
                          activeThumbColor: Colors.orange,
                          onChanged: (val) async {
                            // Toggle open/close status. 
                            // Using a simplified update method since full update is heavy.
                            // We need a toggle method in Service or use updateBusiness.
                            // Assuming updateBusiness handles it roughly.
                            final updatedShop = shop.copyWith(isOpen: val);
                            await SupabaseService.updateBusiness(updatedShop);
                            _loadShops();
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

