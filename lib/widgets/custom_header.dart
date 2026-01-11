/// Custom Header Widget
///
/// Displays the app header with location information, profile picture,
/// and search functionality. Features a blue gradient background with
/// rounded bottom corners.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:town_seek/screens/profile/profile_page.dart';

import '../search/shop_search_delegate.dart';
import '../data/user_manager.dart'; // Import UserManager
import '../screens/main/qr_scanner_screen.dart';

class CustomHeader extends StatelessWidget {
  final bool showBackButton;
  final String? title;
  final VoidCallback? onBack;
  final VoidCallback? onSearchTap;

  const CustomHeader({super.key, this.showBackButton = false, this.title, this.onBack, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF2962FF),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
      decoration: const BoxDecoration(
        color: Color(0xFFf7f7f7), // The stroke color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 1), // Thickness of the bottom stroke
      child: Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
        decoration: const BoxDecoration(
          color: Color(0xFF2962FF), // The main blue color
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(29), // Slightly smaller radius? Or same is mostly fine visually for 1px
            bottomRight: Radius.circular(29),
          ),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            // Back Button (if enabled)
            // Back Button (if enabled)
            if (showBackButton)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0), // increased padding slightly for spacing
                child: GestureDetector(
                  onTap: onBack ?? () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  ),
                ),
              ),

          // Top Row: Location/Title/Profile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Location Text OR Title
              if (title != null)
                Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Current Location",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "New York, USA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              
              // Profile Picture & QR Scan
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: ListenableBuilder(
                      listenable: UserManager.instance,
                      builder: (context, child) {
                        final user = UserManager.instance;
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            image: DecorationImage(
                              image: user.localImageFile != null
                                  ? FileImage(user.localImageFile!) as ImageProvider
                                  : NetworkImage(user.profileImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20), // Increased spacing between location and search bar
          // Search Bar - full width below the location text
          GestureDetector(
            onTap: onSearchTap ?? () {
              showSearch(
                context: context,
                delegate: ShopSearchDelegate(),
              );
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0), // Added padding
                      child: Icon(Icons.search, color: Colors.grey, size: 40),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
      ),
    );
  }
}
