import 'package:flutter/material.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/utils/ui_utils.dart';

class RestaurantOrderScreen extends StatefulWidget {
  final Business business;

  const RestaurantOrderScreen({super.key, required this.business});

  @override
  State<RestaurantOrderScreen> createState() => _RestaurantOrderScreenState();
}

class _RestaurantOrderScreenState extends State<RestaurantOrderScreen> {
  final List<Map<String, dynamic>> _foodItems = [
    {'name': 'Classic Burger', 'price': 150, 'image': '🍔'},
    {'name': 'Cheese Pizza', 'price': 250, 'image': '🍕'},
    {'name': 'Pasta Alfredo', 'price': 200, 'image': '🍝'},
    {'name': 'Coke', 'price': 40, 'image': '🥤'},
  ];

  final Map<String, int> _cart = {};

  void _updateCart(String name, int delta) {
    setState(() {
      _cart[name] = (_cart[name] ?? 0) + delta;
      if (_cart[name]! <= 0) _cart.remove(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = _cart.values.fold(0, (sum, val) => sum + val);
    int totalPrice = _foodItems.fold(0, (sum, item) => sum + (item['price'] as int) * (_cart[item['name']] ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.business.name),
        backgroundColor: const Color(0xFF2962FF),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: _foodItems.length,
        itemBuilder: (context, index) {
          final item = _foodItems[index];
          final name = item['name'] as String;
          final count = _cart[name] ?? 0;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Text(item['image'] as String, style: const TextStyle(fontSize: 35)),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Rs ${item['price']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   if (count > 0) IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.blue), onPressed: () => _updateCart(name, -1)),
                   if (count > 0) Text(count.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                   IconButton(icon: const Icon(Icons.add_circle, color: Colors.blue), onPressed: () => _updateCart(name, 1)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: totalItems > 0 ? Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2962FF),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: () => _showOrderPopup(context, totalItems, totalPrice),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Checkout ($totalItems items)", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Text("Rs $totalPrice", style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ) : null,
    );
  }

  void _showOrderPopup(BuildContext context, int count, int price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Order"),
        content: Text("You are ordering $count items for Rs $price. Proceed?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _cart.clear());
              UIUtils.showPopup(context, "Order placed successfully! We'll deliver soon.");
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
