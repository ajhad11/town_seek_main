import 'package:flutter/material.dart';

class ReviewModerationScreen extends StatefulWidget {
  const ReviewModerationScreen({super.key});

  @override
  State<ReviewModerationScreen> createState() => _ReviewModerationScreenState();
}

class _ReviewModerationScreenState extends State<ReviewModerationScreen> {
  String _filterStatus = 'all'; // all, pending, approved, flagged

  final List<AdminReview> _reviews = [
    AdminReview(
      id: '1',
      author: 'User123',
      shop: 'Tech Store Pro',
      rating: 5,
      text: 'Great products and fast delivery!',
      status: 'pending',
      createdAt: DateTime.now(),
    ),
    AdminReview(
      id: '2',
      author: 'ShopperX',
      shop: 'Fashion Hub',
      rating: 1,
      text: 'Terrible quality, waste of money!!!',
      status: 'flagged',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review Moderation',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Monitor and manage customer reviews',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: _filterStatus,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(
                      value: 'approved',
                      child: Text('Approved'),
                    ),
                    DropdownMenuItem(value: 'flagged', child: Text('Flagged')),
                  ],
                  onChanged: (value) {
                    setState(() => _filterStatus = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) =>
                    _buildReviewCard(_reviews[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(AdminReview review) {
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
        border: review.status == 'flagged'
            ? Border.all(color: Colors.red.shade300, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.author,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'on ${review.shop}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          return Icon(
                            Icons.star_rounded,
                            color: i < review.rating
                                ? Colors.amber
                                : Colors.grey[300],
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 12),
                        Text(
                          '${review.rating} stars',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(review.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  review.status.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(review.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(review.text, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Row(
                children: [
                  if (review.status == 'pending')
                    TextButton.icon(
                      onPressed: () => _approveReview(review),
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text('Approve'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  TextButton.icon(
                    onPressed: () => _deleteReview(review),
                    icon: const Icon(Icons.delete_rounded),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                  if (review.status != 'flagged')
                    TextButton.icon(
                      onPressed: () => _flagReview(review),
                      icon: const Icon(Icons.flag_rounded),
                      label: const Text('Flag'),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.amber;
      case 'flagged':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _approveReview(AdminReview review) {
    setState(() => review.status = 'approved');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Review approved')));
  }

  void _deleteReview(AdminReview review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Delete this review permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _reviews.remove(review));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Review deleted')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _flagReview(AdminReview review) {
    setState(() => review.status = 'flagged');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Review flagged for review')));
  }
}

class AdminReview {
  final String id;
  final String author;
  final String shop;
  final int rating;
  final String text;
  String status;
  final DateTime createdAt;

  AdminReview({
    required this.id,
    required this.author,
    required this.shop,
    required this.rating,
    required this.text,
    required this.status,
    required this.createdAt,
  });
}
