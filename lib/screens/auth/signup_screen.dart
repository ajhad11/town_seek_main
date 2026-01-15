import 'package:flutter/material.dart';
import 'package:town_seek/services/supabase_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:town_seek/utils/ui_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const Color primaryBlue = Color(0xFF2962FF);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || name.isEmpty) {
      UIUtils.showPopup(context, 'Please fill in all fields', isError: true);
      return;
    }

    if (password != confirmPassword) {
      UIUtils.showPopup(context, 'Passwords do not match', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService.signUp(
        email: email, 
        password: password,
        data: {'full_name': name},
      );
      if (mounted) {
        UIUtils.showPopup(context, 'Registration successful! You can now log in.');
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } on AuthException catch (e) {
      if (mounted) {
        UIUtils.showPopup(context, 'Sign up failed: ${e.message}', isError: true);
      }
    } catch (e) {
      if (mounted) {
        UIUtils.showPopup(context, 'Sign up failed: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
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
                const SizedBox(height: 6),
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back, size: 32),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Sign-up",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Full Name",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                _BlueTextField(controller: _nameController),
                const SizedBox(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                _BlueTextField(controller: _emailController),
                const SizedBox(height: 20),
                const Text(
                  "Password",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                _BlueTextField(
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Confirm Password",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                _BlueTextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      _BlueButton(
                        text: "Sign-up",
                        onPressed: _handleSignUp,
                      ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        decorationColor: SignUpScreen.primaryBlue,
                        decorationThickness: 1.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BlueTextField extends StatefulWidget {
  final bool obscureText;
  final TextEditingController controller;
  const _BlueTextField({
    required this.controller,
    this.obscureText = false,
  });

  @override
  State<_BlueTextField> createState() => _BlueTextFieldState();
}

class _BlueTextFieldState extends State<_BlueTextField> {
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
        color: SignUpScreen.primaryBlue,
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

class _BlueButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _BlueButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SignUpScreen.primaryBlue,
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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

