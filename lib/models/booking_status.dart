enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled;

  String toUpperCase() => name.toUpperCase();
}

extension BookingStatusExtension on BookingStatus {
  static BookingStatus fromString(String value) {
    return BookingStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => BookingStatus.pending,
    );
  }
}

