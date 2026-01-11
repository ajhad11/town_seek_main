import 'package:flutter/material.dart';
import 'package:town_seek/models/booking.dart';
import 'package:town_seek/models/booking_status.dart';
import 'package:town_seek/services/supabase_service.dart';

class OrderBookingManagementScreen extends StatefulWidget {
  final String shopId;
  const OrderBookingManagementScreen({super.key, required this.shopId});

  @override
  State<OrderBookingManagementScreen> createState() => _OrderBookingManagementScreenState();
}

class _OrderBookingManagementScreenState extends State<OrderBookingManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    final bookings = await SupabaseService.getBusinessBookings(widget.shopId);
    setState(() {
      _bookings = bookings;
      _isLoading = false;
    });
  }

  List<Booking> _filterBookings(dynamic status) {
    if (status == 'all') return _bookings;
    return _bookings.where((b) => b.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders & Bookings'),
        backgroundColor: const Color(0xFF2962FF),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: 'Pending'), Tab(text: 'Confirmed'), Tab(text: 'All')],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
            controller: _tabController,
            children: [
              _buildBookingList(BookingStatus.pending),
              _buildBookingList(BookingStatus.confirmed),
              _buildBookingList('all'),
            ],
          ),
    );
  }

  Widget _buildBookingList(dynamic status) {
    final filtered = _filterBookings(status);
    if (filtered.isEmpty) return _buildEmptyState();
    
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final booking = filtered[index];
        return _BookingActionCard(
          booking: booking,
          onStatusUpdate: (newStatus) async {
             await SupabaseService.updateBookingStatus(booking.id, newStatus);
             _loadBookings();
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text('No bookings found', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _BookingActionCard extends StatelessWidget {
  final Booking booking;
  final Function(String) onStatusUpdate;

  const _BookingActionCard({required this.booking, required this.onStatusUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.serviceType == 'product' ? 'Product Order' : 'Service Booking',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              _buildStatusChip(booking.status),
            ],
          ),
          const Divider(height: 25),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text('Customer ID: ${booking.userId.substring(0, 8)}', style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(booking.bookingDate.toString().split(' ')[0], style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),
          if (booking.status == BookingStatus.pending)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onStatusUpdate(BookingStatus.confirmed.name),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onStatusUpdate(BookingStatus.cancelled.name),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            )
          else if (booking.status == BookingStatus.confirmed)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onStatusUpdate('completed'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2962FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('Mark as Completed'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color color = Colors.grey;
    if (status == BookingStatus.pending) color = Colors.orange;
    if (status == BookingStatus.confirmed) color = Colors.green;
    if (status == BookingStatus.cancelled) color = Colors.red;
    if (status == BookingStatus.completed) color = Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status.name.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
