import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:town_seek/models/business.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/utils/ui_utils.dart';
import 'dart:io';

class ShopProfileManagementScreen extends StatefulWidget {
  final Business business;
  const ShopProfileManagementScreen({super.key, required this.business});

  @override
  State<ShopProfileManagementScreen> createState() =>
      _ShopProfileManagementScreenState();
}

class _ShopProfileManagementScreenState
    extends State<ShopProfileManagementScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late bool _isOpen;
  late bool _hasParking;
  final List<File> _selectedImages = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.business.name);
    _descController = TextEditingController(text: widget.business.description);
    _isOpen = widget.business.isOpen;
    _hasParking = widget.business.facilities?['parking'] ?? false;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    try {
      final updatedBusiness = widget.business.copyWith(
        name: _nameController.text,
        description: _descController.text,
        isOpen: _isOpen,
        facilities: {
          ...widget.business.facilities ?? {},
          'parking': _hasParking,
        },
      );

      await SupabaseService.updateBusiness(updatedBusiness);

      if (mounted) {
        UIUtils.showPopup(context, 'Shop profile updated successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        UIUtils.showPopup(context, 'Failed to update: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Shop Profile'),
        backgroundColor: const Color(0xFF2962FF),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          else
            TextButton(
              onPressed: _saveChanges,
              child: const Text(
                'SAVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildTextField('Shop Name', _nameController),
            const SizedBox(height: 15),
            _buildTextField('Description', _descController, maxLines: 3),
            const SizedBox(height: 25),
            const Text(
              'Operations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Shop Currently Open'),
              subtitle: const Text('Manually toggle shop status on the app'),
              value: _isOpen,
              onChanged: (v) => setState(() => _isOpen = v),
              activeThumbColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('Parking Available'),
              subtitle: const Text('Does your shop provide customer parking?'),
              value: _hasParking,
              onChanged: (v) => setState(() => _hasParking = v),
              activeThumbColor: Colors.blue,
            ),
            const SizedBox(height: 25),
            const Text(
              'Shop Images',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Icon(Icons.add_a_photo, color: Colors.grey),
                    ),
                  ),
                  ..._selectedImages.map(
                    (file) => Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (widget.business.imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.business.imageUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.business.address ?? 'No address set',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Edit on Map'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
