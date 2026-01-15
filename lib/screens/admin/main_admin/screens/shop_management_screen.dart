import 'package:flutter/material.dart';

class ShopManagementScreen extends StatefulWidget {
  const ShopManagementScreen({super.key});

  @override
  State<ShopManagementScreen> createState() => _ShopManagementScreenState();
}

class _ShopManagementScreenState extends State<ShopManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'all'; // all, pending, verified, suspended

  final List<AdminShop> _shops = [
    AdminShop(
      id: '1',
      name: 'Tech Store Pro',
      owner: 'John Retailer',
      location: 'Downtown',
      rating: 4.8,
      status: 'verified',
      products: 156,
      createdAt: DateTime.now(),
    ),
    AdminShop(
      id: '2',
      name: 'Fashion Hub',
      owner: 'Jane Designer',
      location: 'Mall Center',
      rating: 4.5,
      status: 'pending',
      products: 89,
      createdAt: DateTime.now(),
    ),
    AdminShop(
      id: '3',
      name: 'Food Court',
      owner: 'Chef Mike',
      location: 'Uptown',
      rating: 4.9,
      status: 'verified',
      products: 234,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shop Management',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search shops...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _filterStatus,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'verified',
                          child: Text('Verified'),
                        ),
                        DropdownMenuItem(
                          value: 'suspended',
                          child: Text('Suspended'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _filterStatus = value!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: ListView.builder(
                itemCount: _shops.length,
                itemBuilder: (context, index) => _buildShopCard(_shops[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(AdminShop shop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          shop.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              shop.status,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            shop.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(shop.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          shop.owner,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          shop.location,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildStatBadge('${shop.rating}★', Colors.amber),
                  const SizedBox(width: 12),
                  _buildStatBadge('${shop.products} Items', Colors.blue),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _showShopDetails(shop),
                icon: const Icon(Icons.visibility_rounded),
                label: const Text('View'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Edit'),
              ),
              if (shop.status == 'pending')
                TextButton.icon(
                  onPressed: () => _approveShop(shop),
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Approve'),
                  style: TextButton.styleFrom(foregroundColor: Colors.green),
                )
              else
                TextButton.icon(
                  onPressed: () => _suspendShop(shop),
                  icon: const Icon(Icons.block_rounded),
                  label: const Text('Suspend'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'verified':
        return Colors.green;
      case 'pending':
        return Colors.amber;
      case 'suspended':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showShopDetails(AdminShop shop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(shop.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Owner', shop.owner),
            _detailRow('Location', shop.location),
            _detailRow('Rating', '${shop.rating} ⭐'),
            _detailRow('Products', shop.products.toString()),
            _detailRow('Status', shop.status),
            _detailRow(
              'Created',
              '${shop.createdAt.day}/${shop.createdAt.month}/${shop.createdAt.year}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _approveShop(AdminShop shop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Shop'),
        content: Text('Approve ${shop.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => shop.status = 'verified');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${shop.name} approved!')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _suspendShop(AdminShop shop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend Shop'),
        content: Text('Suspend ${shop.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => shop.status = 'suspended');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${shop.name} suspended!')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }
}

class AdminShop {
  final String id;
  final String name;
  final String owner;
  final String location;
  final double rating;
  String status;
  final int products;
  final DateTime createdAt;

  AdminShop({
    required this.id,
    required this.name,
    required this.owner,
    required this.location,
    required this.rating,
    required this.status,
    required this.products,
    required this.createdAt,
  });
}
