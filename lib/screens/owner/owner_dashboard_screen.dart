import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/models/owner_models.dart';

class OwnerDashboardScreen extends StatefulWidget {
  final String shopId;
  const OwnerDashboardScreen({super.key, required this.shopId});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  late ShopStats _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final statsMap = await SupabaseService.getOwnerDashboardStats(
        widget.shopId,
      );
      if (mounted) {
        setState(() {
          _stats = ShopStats(
            totalViews: statsMap['views'] ?? 0,
            wishlistCount: statsMap['wishlist'] ?? 0,
            totalOrders: statsMap['orders'] ?? 0,
            totalRevenue: (statsMap['revenue'] as num).toDouble(),
            rating: (statsMap['rating'] as num).toDouble(),
            viewsComparison: 0.0, // Mock
            revenueComparison: 0.0, // Mock
            // Using dummy chart data if real data is empty
            weeklyViews: [
              ChartPoint('Mon', 10),
              ChartPoint('Tue', 20),
              ChartPoint('Wed', 15),
              ChartPoint('Thu', 30),
              ChartPoint('Fri', 25),
              ChartPoint('Sat', 40),
              ChartPoint('Sun', 35),
            ],
            weeklyRevenue: [
              ChartPoint('Mon', 100),
              ChartPoint('Tue', 200),
              ChartPoint('Wed', 150),
              ChartPoint('Thu', 300),
              ChartPoint('Fri', 250),
              ChartPoint('Sat', 400),
              ChartPoint('Sun', 350),
            ],
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Shop Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF2962FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryGrid(),
                  const SizedBox(height: 30),
                  _buildChartSection(
                    'Traffic Over the Week',
                    _stats.weeklyViews,
                    Colors.blue,
                  ),
                  const SizedBox(height: 25),
                  _buildChartSection(
                    'Revenue Performance',
                    _stats.weeklyRevenue,
                    Colors.green,
                  ),
                  const SizedBox(height: 30),
                  _buildRecentOrdersHeader(),
                  const SizedBox(height: 15),
                  _buildRecentOrdersList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          title: 'Total Views',
          value: _stats.totalViews.toString(),
          icon: Icons.visibility,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Wishlist',
          value: _stats.wishlistCount.toString(),
          icon: Icons.favorite,
          color: Colors.pink,
        ),
        _StatCard(
          title: 'Orders',
          value: _stats.totalOrders.toString(),
          icon: Icons.shopping_bag,
          color: Colors.orange,
        ),
        _StatCard(
          title: 'Revenue',
          value: '₹${_stats.totalRevenue.toInt()}',
          icon: Icons.currency_rupee,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildChartSection(String title, List<ChartPoint> data, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Text(
                            data[index].label,
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                        .toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Orders',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: () {}, child: const Text('View All')),
      ],
    );
  }

  Widget _buildRecentOrdersList() {
    return Column(
      children: List.generate(3, (index) => _OrderTile(index: index)),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final int index;
  const _OrderTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[50],
            child: const Icon(Icons.shopping_bag, size: 20, color: Colors.blue),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #TS-928${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '2 items • ₹45.00',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Pending',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
