import 'package:flutter/material.dart';

class ShopManagementScreen extends StatelessWidget {
  const ShopManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Shop & Business Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          DefaultTabController(
            length: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  isScrollable: true,
                  labelColor: const Color(0xFF2962FF),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF2962FF),
                  tabs: const [
                    Tab(text: "Active Shops (412)"),
                    Tab(text: "Pending Verification (12)"),
                    Tab(text: "Disabled (8)"),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 600,
                  child: TabBarView(
                    children: [
                      _buildShopList(context, isActive: true),
                      _buildShopList(context, isPending: true),
                      _buildShopList(context, isDisabled: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopList(BuildContext context, {bool isActive = false, bool isPending = false, bool isDisabled = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Shop Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Owner')),
            DataColumn(label: Text('Action')),
          ],
          rows: List.generate(
            5,
            (index) => DataRow(cells: [
              DataCell(
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.store, color: Colors.blue),
                    ),
                    const SizedBox(width: 10),
                    Text('Business Name ${index + 1}'),
                  ],
                ),
              ),
              DataCell(const Text('Groceries')),
              DataCell(const Text('Owner Name')),
              DataCell(
                Row(
                  children: [
                    if (isPending) ...[
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Approve', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Reject', style: TextStyle(color: Colors.red)),
                      ),
                    ] else ...[
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                      IconButton(
                        icon: Icon(isDisabled ? Icons.check_circle_outline : Icons.pause_circle_outline, 
                          color: isDisabled ? Colors.green : Colors.orange), 
                        onPressed: () {}
                      ),
                    ],
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
