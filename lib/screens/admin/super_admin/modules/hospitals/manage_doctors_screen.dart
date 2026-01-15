import 'package:flutter/material.dart';
import 'package:town_seek/models/hospital.dart';
import 'package:town_seek/models/doctor.dart';
import 'package:town_seek/services/supabase_service.dart';

class ManageDoctorsScreen extends StatefulWidget {
  final Hospital hospital;
  const ManageDoctorsScreen({super.key, required this.hospital});

  @override
  State<ManageDoctorsScreen> createState() => _ManageDoctorsScreenState();
}

class _ManageDoctorsScreenState extends State<ManageDoctorsScreen> {
  List<Doctor> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);
    try {
      final doctors = await SupabaseService.getDoctors(widget.hospital.id);
      if (!mounted) return;
      setState(() {
        _doctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _showDoctorDialog() {
    final nameController = TextEditingController();
    final specController = TextEditingController();
    final hoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Doctor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextField(controller: specController, decoration: const InputDecoration(labelText: 'Specialization')),
             const SizedBox(height: 10),
            TextField(controller: hoursController, decoration: const InputDecoration(labelText: 'Availability (e.g. 9AM - 5PM)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              
              final newDoctor = Doctor(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                hospitalId: widget.hospital.id,
                name: nameController.text,
                specialization: specController.text,
                availability: {'hours': hoursController.text}, // Simple JSON map
                createdAt: DateTime.now(),
              );

              await SupabaseService.addDoctor(newDoctor);
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);
              if (mounted) _loadDoctors();
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
        title: Text('${widget.hospital.name} - Doctors', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _doctors.isEmpty
              ? const Center(child: Text('No doctors listed'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = _doctors[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(doctor.name[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        title: Text(doctor.name),
                        subtitle: Text('${doctor.specialization}\n${doctor.availability?['hours'] ?? 'Not set'}'),
                        isThreeLine: true,
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDoctorDialog,
        backgroundColor: Colors.red.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

