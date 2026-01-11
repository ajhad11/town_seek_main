import 'dart:math' as math;
import 'package:flutter/material.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

  // App primary color
  static const Color _brandBlue = Color(0xFF2962FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              LayoutBuilder(
                builder: (context, constraints) {
                  final double desiredSize = 120;
                  final double maxWidth = constraints.maxWidth;
                  final double screenHeight = MediaQuery.of(context).size.height;
                  final double size = math.min(
                    desiredSize,
                    math.min(maxWidth * 0.9, screenHeight * 0.2),
                  );

                  return SizedBox(
                    width: size,
                    height: size,
                    child: Image.asset('assets/Logo.png', fit: BoxFit.contain),
                  );
                },
              ),

              const SizedBox(height: 48),

              // Login button
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  key: const Key('login_button'),
                  onPressed: () => Navigator.of(context).pushNamed('/login'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AccountTypeScreen._brandBlue,
                    elevation: 6,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign-in button
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  key: const Key('signin_button'),
                  onPressed: () => Navigator.of(context).pushNamed('/sign_in'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AccountTypeScreen._brandBlue,
                    elevation: 6,
                  ),
                  child: const Text(
                    'Sign-up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
