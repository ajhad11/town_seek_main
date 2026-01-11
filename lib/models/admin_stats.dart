class AdminDashboardStats {
  final int totalUsers;
  final int totalShops;
  final int totalHospitals;
  final int activeListings;
  final List<DailyUserCount> dailyActiveUsers;

  AdminDashboardStats({
    required this.totalUsers,
    required this.totalShops,
    required this.totalHospitals,
    required this.activeListings,
    required this.dailyActiveUsers,
  });

  factory AdminDashboardStats.mock() {
    return AdminDashboardStats(
      totalUsers: 1284,
      totalShops: 456,
      totalHospitals: 42,
      activeListings: 1890,
      dailyActiveUsers: [
        DailyUserCount(day: 'Mon', count: 120),
        DailyUserCount(day: 'Tue', count: 150),
        DailyUserCount(day: 'Wed', count: 200),
        DailyUserCount(day: 'Thu', count: 180),
        DailyUserCount(day: 'Fri', count: 250),
        DailyUserCount(day: 'Sat', count: 300),
        DailyUserCount(day: 'Sun', count: 280),
      ],
    );
  }
}

class DailyUserCount {
  final String day;
  final int count;

  DailyUserCount({required this.day, required this.count});
}
