import 'package:flutter/material.dart';

class ReviewModerationScreen extends StatelessWidget {
  const ReviewModerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reviews & Moderation', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 8,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(child: Icon(Icons.person)),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Anonymous User', style: TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < 4 ? Colors.amber : Colors.grey[300])),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text('Review for: Sunny Cafe', style: TextStyle(color: Color(0xFF2962FF), fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Text('The service was a bit slow, but the food was absolutely amazing. I would definitely recommend the classic burger!'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Posted on: 12th Jan 2024', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                              const Spacer(),
                              TextButton.icon(
                                icon: const Icon(Icons.flag_outlined, size: 16, color: Colors.orange),
                                label: const Text('Flag', style: TextStyle(color: Colors.orange)),
                                onPressed: () {},
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                                label: const Text('Delete', style: TextStyle(color: Colors.red)),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
