import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Slightly decreased height
      decoration: const BoxDecoration(
        color: Color(0xFF2962FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 10), // Move icons up
      alignment: Alignment.center, // Center the Row vertically
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(Icons.home_filled, 0),
          _buildNavItem(Icons.location_on, 1),
          _buildNavItem(Icons.favorite, 2),
          _buildNavItem(Icons.person, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque, // Ensure tap area is consistent
      child: isSelected
          ? Container(
              width: 90,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0x80D9D9D9),
                  width: 1,
                ),
              ),
              alignment: Alignment.center, // Center the Icon
              child: Icon(
                icon,
                color: const Color(0xFF2962FF),
                size: 30, // Adjusted size
              ),
            )
          : Container(
              width: 90,
              height: 45,
              alignment: Alignment.center, // Center the Icon
              child: Icon(
                icon,
                color: Colors.white.withValues(alpha: 0.9), // Slight opacity for unselected
                size: 30,
              ),
            ),
    );
  }
}
