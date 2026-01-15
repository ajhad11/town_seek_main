/// Shop Card Widget & Model
///
/// Contains the Shop data model and the ShopCard widget for displaying shop details.
library;

import 'package:flutter/material.dart';
import 'shop_tag.dart';

/// Data Model for Shop Information
class Doctor {
  final String name;
  final String speciality;
  final String qualification;
  final String availability;
  final String imageUrl;

  const Doctor({
    required this.name,
    required this.speciality,
    required this.qualification,
    required this.availability,
    this.imageUrl = "",
  });
}

class ServiceItem {
  final String name;
  final String price; // e.g., "Rs 300 /PCS"
  final String imageUrl;

  const ServiceItem({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class Shop {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String rating;
  final List<String> tags;
  final bool isOpen;
  final List<String>? facilities;
  final List<Doctor>? doctors;
  final List<ServiceItem>? services;

  const Shop({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.tags,
    required this.isOpen,
    this.facilities,
    this.doctors,
    this.services,
  });
}

/// Individual Shop Card Widget
class ShopCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String rating;
  final List<String> tags;
  final bool isOpen;
  final String? distance;
  final bool hasParking;

  const ShopCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.tags,
    required this.isOpen,
    this.distance,
    this.hasParking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x80D9D9D9),
          width: 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Shop Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
                  Container(width: 100, height: 100, color: Colors.grey[300], child: const Icon(Icons.broken_image, color: Colors.white70)),
            ),
          ),
          const SizedBox(width: 15),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.star, size: 12, color: Colors.orange),
                          const SizedBox(width: 2),
                          Text(
                            rating,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 10),
                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: tags.map<Widget>((String tag) => ShopTag(text: tag)).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (distance != null) ...[
                            const Icon(Icons.location_on, size: 14, color: Colors.blue),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                distance!,
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          if (hasParking) ...[
                            const Icon(Icons.local_parking, size: 14, color: Colors.green),
                            const SizedBox(width: 4),
                            const Text("Parking", style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOpen ? "OPEN" : "CLOSED",
                      style: TextStyle(
                        color: isOpen ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
