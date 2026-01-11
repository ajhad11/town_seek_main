import 'package:flutter/material.dart';
import 'package:town_seek/services/supabase_service.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await SupabaseService.getAdminAllUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text('No users found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    final isBlocked = user['is_blocked'] == 1;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user['avatar_url'] != null ? NetworkImage(user['avatar_url']) : null,
                          child: user['avatar_url'] == null ? const Icon(Icons.person) : null,
                        ),
                        title: Text(user['full_name'] ?? 'Unknown'),
                        subtitle: Text(user['email'] ?? ''),
                        trailing: PopupMenuButton(
                          onSelected: (value) async {
                            if (value == 'toggle') {
                              await SupabaseService.toggleUserBlock(user['id'], !isBlocked);
                              _loadUsers();
                            } else if (value == 'delete') {
                              await SupabaseService.deleteUser(user['id']);
                              _loadUsers();
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'toggle',
                              child: Text(isBlocked ? 'Unblock' : 'Block', style: TextStyle(color: isBlocked ? Colors.green : Colors.red)),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
