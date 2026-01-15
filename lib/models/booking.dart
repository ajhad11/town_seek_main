import 'booking_status.dart';

class Booking {
  final String id;
  final String userId;
  final String businessId;
  final String? serviceId;
  final Map<String, dynamic>? itemDetails;
  final BookingStatus status;
  final DateTime bookingDate;
  final double? totalPrice;
  final String? notes;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.businessId,
    this.serviceId,
    this.itemDetails,
    required this.status,
    required this.bookingDate,
    this.totalPrice,
    this.notes,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      businessId: json['business_id'],
      serviceId: json['service_id'],
      itemDetails: json['item_details'] != null ? Map<String, dynamic>.from(json['item_details']) : null,
      status: BookingStatusExtension.fromString(json['status']),
      bookingDate: DateTime.parse(json['booking_date']),
      totalPrice: json['total_price']?.toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get serviceType => serviceId != null ? 'service' : 'product';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'business_id': businessId,
      'service_id': serviceId,
      'item_details': itemDetails,
      'status': status.name,
      'booking_date': bookingDate.toIso8601String(),
      'total_price': totalPrice,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

