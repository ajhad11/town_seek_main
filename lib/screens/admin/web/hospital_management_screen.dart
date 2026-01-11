import 'package:flutter/material.dart';

class HospitalManagementScreen extends StatelessWidget {
  const HospitalManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hospital & Services', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_business, color: Colors.white),
                label: const Text('Register Hospital', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2962FF)),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(child: _HospitalStatCard(title: 'Active Hospitals', value: '42', icon: Icons.local_hospital, color: Colors.red)),
              const SizedBox(width: 20),
              Expanded(child: _HospitalStatCard(title: 'Total Doctors', value: '1,240', icon: Icons.person, color: Colors.blue)),
              const SizedBox(width: 20),
              Expanded(child: _HospitalStatCard(title: 'Appointments Today', value: '156', icon: Icons.calendar_today, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hospital List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Hospital Name')),
                    DataColumn(label: Text('Location')),
                    DataColumn(label: Text('Doctors')),
                    DataColumn(label: Text('Joined')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: List.generate(
                    4,
                    (index) => DataRow(cells: [
                      DataCell(Text('City Hospital ${index + 1}')),
                      DataCell(Text('Downtown, Block B')),
                      DataCell(Text('${20 + index * 5}')),
                      DataCell(Text('12/01/2023')),
                      DataCell(
                        Row(
                          children: [
                            TextButton(onPressed: () {}, child: const Text('Manage Doctors')),
                            IconButton(icon: const Icon(Icons.settings, color: Colors.grey), onPressed: () {}),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HospitalStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _HospitalStatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
