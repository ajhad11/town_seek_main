class Review {
  final String id;
  final String userId;
  final String businessId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final String? userName;
  final String? userAvatar;

  final String? reply;

  Review({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.userName,
    this.userAvatar,
    this.reply,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    // Check for joined profile data
    final profileData = json['profiles'];
    final Map<String, dynamic>? profile = profileData != null ? Map<String, dynamic>.from(profileData) : null;
    
    return Review(
      id: json['id'],
      userId: json['user_id'],
      businessId: json['business_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      userName: profile != null ? profile['full_name'] : null,
      userAvatar: profile != null ? profile['avatar_url'] : null,
      reply: json['reply'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'user_id': userId,
      'business_id': businessId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'reply': reply,
    };
  }
}

