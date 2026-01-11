import 'package:flutter/material.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/models/booking.dart';
import 'package:town_seek/models/booking_status.dart';

class BusinessBookingsScreen extends StatefulWidget {
  final String businessId;

  const BusinessBookingsScreen({super.key, required this.businessId});

  @override
  State<BusinessBookingsScreen> createState() => _BusinessBookingsScreenState();
}

class _BusinessBookingsScreenState extends State<BusinessBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _allBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    try {
      final bookings = await SupabaseService.getBusinessBookings(
        widget.businessId,
      );
      if (!mounted) return;
      setState(() {
        _allBookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading bookings: $e')));
    }
  }

  List<Booking> _filterBookings(String status) {
    if (status == 'all') return _allBookings;
    final targetStatus = BookingStatusExtension.fromString(status);
    return _allBookings.where((b) => b.status == targetStatus).toList();
  }

  Future<void> _updateBookingStatus(Booking booking, String newStatus) async {
    try {
      await SupabaseService.updateBookingStatus(booking.id, newStatus);
      if (!mounted) return;
      _loadBookings();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking status updated')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating status: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Orders & Bookings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadBookings,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              _buildHeaderInfo(),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: 'ALL'),
                  Tab(text: 'PENDING'),
                  Tab(text: 'CONFIRMED'),
                  Tab(text: 'COMPLETED'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade800, Colors.grey[50]!],
            stops: const [0.0, 0.3],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList('all'),
                  _buildBookingsList('pending'),
                  _buildBookingsList('confirmed'),
                  _buildBookingsList('completed'),
                ],
              ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keep track of your business',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          Text(
            '${_allBookings.length} Total activities',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(String status) {
    final bookings = _filterBookings(status);

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_edu_rounded,
                size: 80,
                color: Colors.orange.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No ${status == 'all' ? '' : status} entries',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 120, 16, 20),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    Color statusColor;
    IconData statusIcon;

    switch (booking.status) {
      case BookingStatus.confirmed:
        statusColor = Colors.green.shade600;
        statusIcon = Icons.verified_rounded;
        break;
      case BookingStatus.pending:
        statusColor = Colors.amber.shade700;
        statusIcon = Icons.hourglass_top_rounded;
        break;
      case BookingStatus.completed:
        statusColor = Colors.blue.shade600;
        statusIcon = Icons.task_alt_rounded;
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red.shade600;
        statusIcon = Icons.cancel_rounded;
        break;

    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          booking.serviceType == 'product'
              ? 'Product Order'
              : 'Service Booking',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 12,
              color: Colors.grey[400],
            ),
            const SizedBox(width: 4),
            Text(
              _formatDate(booking.bookingDate),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            booking.status.toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 12),
                _buildInfoRow('Ref ID', booking.id, Icons.tag_rounded),
                _buildInfoRow(
                  'Customer',
                  booking.userId,
                  Icons.person_outline_rounded,
                ),
                if (booking.notes != null)
                  _buildInfoRow(
                    'Instructions',
                    booking.notes!,
                    Icons.sticky_note_2_outlined,
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (booking.status != BookingStatus.pending)
                        _buildStatusButton(
                          booking,
                          'pending',
                          Colors.amber.shade700,
                          Icons.hourglass_empty_rounded,
                        ),
                      if (booking.status != BookingStatus.confirmed)
                        _buildStatusButton(
                          booking,
                          'confirmed',
                          Colors.green.shade600,
                          Icons.check_circle_outline_rounded,
                        ),
                      if (booking.status != BookingStatus.completed)
                        _buildStatusButton(
                          booking,
                          'completed',
                          Colors.blue.shade600,
                          Icons.done_all_rounded,
                        ),
                      if (booking.status != BookingStatus.cancelled)
                        _buildStatusButton(
                          booking,
                          'cancelled',
                          Colors.red.shade600,
                          Icons.block_flipped,
                        ),
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

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: Colors.grey[400]),
          const SizedBox(width: 8),
          SizedBox(
            width: 85,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
    Booking booking,
    String status,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton.icon(
        onPressed: () => _updateBookingStatus(booking, status),
        icon: Icon(icon, size: 16),
        label: Text(status.toUpperCase()),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
