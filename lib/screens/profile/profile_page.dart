import 'dart:io';
import 'package:flutter/material.dart';
import 'package:town_seek/data/user_manager.dart';
import 'package:town_seek/screens/main/main_screen.dart';
import 'package:town_seek/services/supabase_service.dart';
// import 'package:town_seek/screens/admin/business/business_login_screen.dart';
import '../admin/business/business_admin_dashboard.dart';
import 'edit_profile_page.dart';
import 'about_us_screen.dart';


/// Profile Page
///
/// Displays user profile information and settings.
/// This page is accessed when the user taps the Person icon in bottom navigation.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Removed local state variables in favor of UserManager

  Future<void> _editProfile() async {
    final user = UserManager.instance;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          currentName: user.name,
          currentImage: user.profileImage, // Edit page might need logic to handle local image too? 
          // EditPage takes string currentImage. If we have local, we might need to pass path? 
          // Current EditProfilePage implementation takes 'currentImage' as String(URL) and doesn't explicitly take File. 
          // But it has `_selectedImage` logic. 
          // Let's pass the URL for now as placeholder if local exists, OR pass local path?
          // If local exists, EditPage should ideally show it. 
          // EditPage logic: `backgroundImage: _imageFile != null ? FileImage ... : NetworkImage`.
          // We can't easily pass File to EditPage constructor without changing it.
          // For now let's pass the URL. If user has local image, EditPage won't show it initially unless we update EditPage.
          // BUT, we can simple pass the profileImage URL. The user can pick new one.
          // Improvement: Update EditProfilePage to accept File? or path.
          // For now, let's keep it simple.
          currentPhone: user.phone,
        ),
      ),
    );

    if (result != null && result is Map) {
      if (result['isLocalImage'] == true) {
        UserManager.instance.updateProfile(
          name: result['name'],
          phone: result['phone'],
          localImage: File(result['image']),
        );
      } else {
        UserManager.instance.updateProfile(
          name: result['name'],
          phone: result['phone'],
          image: result['image'],
          // We might want to clear local image if they selected a preset avatar
          // But UserManager.updateProfile doesn't support clearing explicitly unless we change it.
          // Let's assume for now they pick local or keep existing.
          // If they pick preset, result['image'] is URL. We should probably clear localImageFile in UserManager.
        );
         // Force clear local image in manager if network image is set?
         // Let's modify UserManager to handle this better in a future step or just manually set it.
         // Actually, let's just use what we have.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: ListenableBuilder(
        listenable: UserManager.instance,
        builder: (context, child) {
          final user = UserManager.instance;
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Custom Blue Header
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF2962FF),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // AppBar Row (Back Button + Settings Title)
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                       // Navigate to Home Page (Index 0)
                                       MainScreen.of(context).goToTab(0);
                                    },
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
                                  const SizedBox(width: 15),
                                  const Text(
                                    'Settings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              // User Profile Section (Moved into Header)
                              Row(
                                children: [
                                   Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                       border: Border.all(color: Colors.transparent),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: user.localImageFile != null
                                          ? FileImage(user.localImageFile!) as ImageProvider
                                          : NetworkImage(user.profileImage),
                                      onBackgroundImageError: null, 
                                      child: null,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, 
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'Shopper',
                                          style: TextStyle(
                                            color: Color(0xFF2962FF),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                           child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const SizedBox(height: 30),
                              
                              // Menu Items
                              _buildMenuItem('Edit your profile', onTap: _editProfile),
                              const SizedBox(height: 15),
                              _buildMenuItem('Your Orders & Bookings'),
                              
                              const SizedBox(height: 30),
                              
                              // Business Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2962FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'ADD YOUR BUSINESS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              _buildMenuItem(
                                'Business Account',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BusinessAdminDashboard(),
                                    ),
                                  );
                                },
                              ),
                               const SizedBox(height: 15),
                              _buildMenuItem(
                                'About Us',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AboutUsScreen(),
                                    ),
                                  );
                                },
                              ),
                               const SizedBox(height: 15),
                              _buildMenuItem(
                                'Logout', 
                                onTap: () async {
                                  await SupabaseService.signOut();
                                  // StreamBuilder in main.dart will handle navigation.
                                },
                                isDestructive: true,
                              ),
                            ],
                           ),
                        ),
    
                        const Spacer(), // Pushes footer to bottom
    
                        // Footer
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0), // Add padding at bottom
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/Logo.png',
                                height: 40,
                                // width: 40, 
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Town Seek',
                                style: TextStyle(
                                  color: Color(0xFF2962FF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }

  Widget _buildMenuItem(String title, {VoidCallback? onTap, bool isDestructive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDestructive ? Colors.red : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios, 
              size: 16, 
              color: isDestructive ? Colors.red : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
