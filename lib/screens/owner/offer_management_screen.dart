import 'package:flutter/material.dart';
import 'package:town_seek/services/supabase_service.dart';

class OfferManagementScreen extends StatefulWidget {
  final String shopId;
  const OfferManagementScreen({super.key, required this.shopId});

  @override
  State<OfferManagementScreen> createState() => _OfferManagementScreenState();
}

class _OfferManagementScreenState extends State<OfferManagementScreen> {
  List<Map<String, dynamic>> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    setState(() => _isLoading = true);
    final offers = await SupabaseService.getShopOffers(widget.shopId);
    setState(() {
      _offers = offers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers & Promotions'),
        backgroundColor: const Color(0xFF2962FF),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2962FF),
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Offer', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _offers.length,
            itemBuilder: (context, index) {
              final offer = _offers[index];
              return _buildOfferCard(offer);
            },
          ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    final bool isActive = offer['status'] == 'active';
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isActive ? Colors.orange[50] : Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isActive ? Colors.orange : Colors.grey,
                  child: const Icon(Icons.local_offer, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offer['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${offer['discount']}% Discount • Expiring ${offer['expiry']}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                Switch(value: isActive, onChanged: (v) {}),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _OfferStat(label: 'Redeemed', value: '45'),
                _OfferStat(label: 'Views', value: '1,200'),
                _OfferStat(label: 'Revenue', value: '\$2,450'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferStat extends StatelessWidget {
  final String label;
  final String value;
  const _OfferStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
      ],
    );
  }
}
