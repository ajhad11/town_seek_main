import 'package:flutter/material.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/models/business.dart';

class BusinessRegistrationScreen extends StatefulWidget {
  const BusinessRegistrationScreen({super.key});

  @override
  State<BusinessRegistrationScreen> createState() => _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState extends State<BusinessRegistrationScreen> {
  bool _isLoading = false;

  Future<void> _refreshStatus() async {
    setState(() => _isLoading = true);
    // Refreshing logic usually involves checking if business now exists
    final business = await SupabaseService.getBusinessForCurrentUser();
    if (mounted) {
      setState(() => _isLoading = false);
      if (business != null) {
        // Business found, root will re-route
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color(0xFF2962FF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.storefront_rounded, size: 80, color: const Color(0xFF2962FF).withValues(alpha: 0.5)),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Business Registered',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'You need to register your business to access the admin control panel.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => _showRegisterBusinessDialog(context),
                  icon: const Icon(Icons.add_business_rounded),
                  label: const Text('REGISTER MY BUSINESS', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2962FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : _refreshStatus,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Refresh Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRegisterBusinessDialog(BuildContext context) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
            top: 25,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Register Business',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                Text('Fill in the details to launch your digital store.', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 24),
                _simpleTextField(nameController, 'Business Name', Icons.business_rounded),
                const SizedBox(height: 16),
                _simpleTextField(categoryController, 'Category', Icons.category_outlined, hint: 'Restaurant, Salon, etc.'),
                const SizedBox(height: 16),
                _simpleTextField(descriptionController, 'Description', Icons.description_outlined, maxLines: 3),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : () async {
                      if (nameController.text.isEmpty || categoryController.text.isEmpty) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('Name and Category are required')),
                        );
                        return;
                      }

                      setDialogState(() => isSaving = true);

                      try {
                        final user = SupabaseService.currentUser;
                        if (user == null) throw 'User not authenticated';

                        final newBusiness = Business(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          ownerId: user.id,
                          name: nameController.text,
                          category: categoryController.text,
                          description: descriptionController.text,
                          createdAt: DateTime.now(),
                          rating: 5.0,
                        );

                        await SupabaseService.createBusiness(newBusiness);
                        
                        if (!context.mounted) return;
                        Navigator.pop(dialogContext);
                        _refreshStatus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Business Registered Successfully!')),
                        );
                      } catch (e) {
                         if (!dialogContext.mounted) return;
                         ScaffoldMessenger.of(dialogContext).showSnackBar(
                           SnackBar(content: Text('Error: $e')),
                         );
                      } finally {
                        setDialogState(() => isSaving = false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2962FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: isSaving 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('CREATE BUSINESS PROFILE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _simpleTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1, String? hint}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue.shade300),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blue.shade300, width: 2)),
      ),
    );
  }
}
