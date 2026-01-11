import 'package:flutter/material.dart';
import 'package:town_seek/services/supabase_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:town_seek/utils/ui_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const Color primaryBlue = Color(0xFF2962FF);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      UIUtils.showPopup(context, 'Please enter email and password', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService.signIn(email: email, password: password);
      if (mounted) {
        // Clear stack and go to root, AuthGate determines where to go
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } on AuthException catch (e) {
      if (mounted) {
        UIUtils.showPopup(context, e.message, isError: true);
      }
    } catch (e) {
      if (mounted) {
        UIUtils.showPopup(context, 'An unexpected error occurred: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to continue using TownSeek',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 60),
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                _BluePillField(controller: _emailController),
                const SizedBox(height: 28),
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                _BluePillField(
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        _BluePillButton(
                          text: 'Login',
                          onPressed: _handleLogin,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Column(
                    children: [
                      const Text("Don't have an account?", style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed('/sign_in'),
                        child: const Text(
                          'Create New Account',
                          style: TextStyle(
                            fontSize: 18,
                            color: LoginScreen.primaryBlue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BluePillField extends StatefulWidget {
  final bool obscureText;
  final TextEditingController controller;
  const _BluePillField({
    required this.controller,
    this.obscureText = false,
  });

  @override
  State<_BluePillField> createState() => _BluePillFieldState();
}

class _BluePillFieldState extends State<_BluePillField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: LoginScreen.primaryBlue,
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _BluePillButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _BluePillButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LoginScreen.primaryBlue,
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
