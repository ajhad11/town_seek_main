import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/screens/common/location_picker_screen.dart';

class BusinessSettingsScreen extends StatefulWidget {
  final Business business;

  const BusinessSettingsScreen({
    super.key,
    required this.business,
  });

  @override
  State<BusinessSettingsScreen> createState() => _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends State<BusinessSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _addressController;
  late TextEditingController _imageUrlController;
  double? _latitude;
  double? _longitude;
  bool _isOpen = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.business.name);
    _descriptionController =
        TextEditingController(text: widget.business.description);
    _categoryController = TextEditingController(text: widget.business.category);
    _addressController = TextEditingController(text: widget.business.address);
    _imageUrlController = TextEditingController(text: widget.business.imageUrl);
    _isOpen = widget.business.isOpen;
    _latitude = widget.business.latitude;
    _longitude = widget.business.longitude;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _addressController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business name is required')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedBusiness = Business(
        id: widget.business.id,
        ownerId: widget.business.ownerId,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        category: _categoryController.text.isEmpty
            ? null
            : _categoryController.text,
        address: _addressController.text.isEmpty
            ? null
            : _addressController.text,
        imageUrl: _imageUrlController.text.isEmpty
            ? null
            : _imageUrlController.text,
        latitude: _latitude,
        longitude: _longitude,
        rating: widget.business.rating,
        tags: widget.business.tags,
        isOpen: _isOpen,
        facilities: widget.business.facilities,
        metadata: widget.business.metadata,
        createdAt: widget.business.createdAt,
      );

      await SupabaseService.updateBusiness(updatedBusiness);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Business Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
              onPressed: _saveSettings,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildSection(
                    title: 'IDENTITY',
                    icon: Icons.badge_outlined,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Business Name',
                        icon: Icons.business_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _categoryController,
                        label: 'Category',
                        icon: Icons.category_outlined,
                        hint: 'e.g. Restaurant, Salon, Boutique',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _addressController,
                        label: 'Physical Address',
                        icon: Icons.place_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.map_rounded, color: Colors.blue.shade700),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Map Location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    _latitude != null && _longitude != null
                                        ? 'Lat: ${_latitude!.toStringAsFixed(4)}, Lng: ${_longitude!.toStringAsFixed(4)}'
                                        : 'Not set',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LocationPickerScreen(
                                      initialLatitude: _latitude,
                                      initialLongitude: _longitude,
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    _latitude = result.latitude;
                                    _longitude = result.longitude;
                                  });
                                }
                              },
                              icon: const Icon(Icons.edit_location_alt_outlined),
                              label: const Text('Set'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _imageUrlController,
                        label: 'Banner Image URL',
                        icon: Icons.image_search_rounded,
                        onChanged: (val) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        icon: Icons.description_outlined,
                        maxLines: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'PRESENCE',
                    icon: Icons.location_on_outlined,
                    children: [
                      _buildTextField(
                        controller: _addressController,
                        label: 'Physical Address',
                        icon: Icons.place_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _imageUrlController.text = image.path;
                            });
                          }
                        },
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            image: _imageUrlController.text.isNotEmpty
                                ? DecorationImage(
                                    image: _imageUrlController.text.startsWith('http')
                                        ? NetworkImage(_imageUrlController.text)
                                        : FileImage(File(_imageUrlController.text))
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo_rounded, size: 48, color: Colors.indigo),
                                      SizedBox(height: 8),
                                      Text('Tap to upload banner', style: TextStyle(color: Colors.indigo)),
                                    ],
                                  ),
                                )
                              : null,
                        ),
                      ),
                      if (_imageUrlController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextButton.icon(
                            onPressed: () => setState(() => _imageUrlController.clear()),
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            label: const Text('Remove Image', style: TextStyle(color: Colors.red)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'OPERATIONAL STATUS',
                    icon: Icons.settings_power_rounded,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SwitchListTile(
                          title: const Text('Open for business', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            _isOpen ? 'Customers can find and book your services' : 'Storefront is currently hidden from search',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          value: _isOpen,
                          onChanged: (value) => setState(() => _isOpen = value),
                          activeThumbColor: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'SYSTEM INFORMATION',
                    icon: Icons.info_outline_rounded,
                    children: [
                      _buildSystemInfoRow('Digital ID', widget.business.id),
                      _buildSystemInfoRow('Global Rating', widget.business.rating.toStringAsFixed(1)),
                      _buildSystemInfoRow('Registry Date', _formatDate(widget.business.createdAt)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade800,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('UPDATE BUSINESS PROFILE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
      decoration: BoxDecoration(
        color: Colors.indigo.shade900,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Storefront',
            style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 2, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.business.name,
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${widget.business.rating.toStringAsFixed(1)} Business Rating',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.indigo.shade800),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.indigo.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? hint,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.indigo.shade300, width: 2),
        ),
      ),
    );
  }

  Widget _buildSystemInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
