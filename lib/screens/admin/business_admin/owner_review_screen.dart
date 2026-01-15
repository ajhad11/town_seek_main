import 'package:flutter/material.dart';
import 'package:town_seek/models/review.dart';
import 'package:town_seek/services/supabase_service.dart';

class OwnerReviewScreen extends StatefulWidget {
  final String shopId;
  const OwnerReviewScreen({super.key, required this.shopId});

  @override
  State<OwnerReviewScreen> createState() => _OwnerReviewScreenState();
}

class _OwnerReviewScreenState extends State<OwnerReviewScreen> {
  List<Review> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    final reviews = await SupabaseService.getBusinessReviews(widget.shopId);
    setState(() {
      _reviews = reviews;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Reviews'),
        backgroundColor: const Color(0xFF2962FF),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              _buildRatingSummary(),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    return _buildReviewItem(review);
                  },
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          _buildBigRating(),
          const SizedBox(width: 40),
          Expanded(child: _buildRatingBars()),
        ],
      ),
    );
  }

  Widget _buildBigRating() {
    return Column(
      children: [
        const Text('4.5', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        Row(
          children: List.generate(5, (i) => Icon(Icons.star, size: 16, color: i < 4 ? Colors.amber : Colors.grey[300])),
        ),
        const SizedBox(height: 5),
        const Text('124 reviews', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildRatingBars() {
    return Column(
      children: [
        _buildProgressBar(5, 0.8),
        _buildProgressBar(4, 0.15),
        _buildProgressBar(3, 0.03),
        _buildProgressBar(2, 0.01),
        _buildProgressBar(1, 0.01),
      ],
    );
  }

  Widget _buildProgressBar(int stars, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$stars', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          const Icon(Icons.star, size: 10, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(value: pct, backgroundColor: Colors.grey[200], color: Colors.amber, minHeight: 6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Anonymous User', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(review.createdAt.toString().split(' ')[0], style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < review.rating ? Colors.amber : Colors.grey[300])),
          ),
          const SizedBox(height: 10),
          Text(review.comment ?? '', style: const TextStyle(height: 1.4)),
          if (review.reply != null)
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Shop Response:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 5),
                  Text(review.reply!, style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                ],
              ),
            )
          else
            TextButton(onPressed: () {}, child: const Text('Reply', style: TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

