import 'package:flutter/material.dart';
import 'package:town_seek/models/hospital.dart';
import 'package:town_seek/services/supabase_service.dart';
import 'package:town_seek/screens/admin/hospitals/manage_doctors_screen.dart';

class ManageHospitalsScreen extends StatefulWidget {
  const ManageHospitalsScreen({super.key});

  @override
  State<ManageHospitalsScreen> createState() => _ManageHospitalsScreenState();
}

class _ManageHospitalsScreenState extends State<ManageHospitalsScreen> {
  List<Hospital> _hospitals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    setState(() => _isLoading = true);
    try {
      final hospitals = await SupabaseService.getAllHospitals();
      if (!mounted) return;
      setState(() {
        _hospitals = hospitals;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _showHospitalDialog({Hospital? hospital}) {
    final nameController = TextEditingController(text: hospital?.name);
    final addressController = TextEditingController(text: hospital?.address);
    final phoneController = TextEditingController(text: hospital?.phone);
    final emailController = TextEditingController(text: hospital?.email);
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(hospital == null ? 'Add Hospital' : 'Edit Hospital'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              
              final newHospital = Hospital(
                id: hospital?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                address: addressController.text,
                phone: phoneController.text,
                email: emailController.text,
                imageUrl: hospital?.imageUrl,
                isActive: hospital?.isActive ?? true,
                createdAt: hospital?.createdAt ?? DateTime.now(),
              );

              // Currently SupabaseService has 'addHospital' but not 'updateHospital'
              
              await SupabaseService.addHospital(newHospital);
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);
              if (mounted) _loadHospitals();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Hospitals', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _hospitals.isEmpty 
              ? const Center(child: Text('No hospitals found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _hospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = _hospitals[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          child: const Icon(Icons.local_hospital, color: Colors.red),
                        ),
                        title: Text(hospital.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${hospital.address}\n${hospital.phone}'),
                        isThreeLine: true,
                        trailing: Switch(
                          value: hospital.isActive,
                          activeThumbColor: Colors.red,
                          onChanged: (val) async {
                            await SupabaseService.toggleHospitalStatus(hospital.id, val);
                            _loadHospitals();
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageDoctorsScreen(hospital: hospital),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showHospitalDialog(),
        backgroundColor: Colors.red.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
