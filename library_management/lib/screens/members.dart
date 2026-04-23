import 'package:flutter/material.dart';
import '../data.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Manage Members', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListenableBuilder(
        listenable: libraryData,
        builder: (context, child) {
          if (libraryData.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('No members registered yet.', style: TextStyle(color: Colors.grey.shade600, fontSize: 18)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: libraryData.users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final user = libraryData.users[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.purple.shade50,
                    child: Text(
                      user.email.isNotEmpty ? user.email[0].toUpperCase() : '?',
                      style: TextStyle(color: Colors.purple.shade700, fontWeight: FontWeight.bold, fontSize: 24)
                    ),
                  ),
                  title: Text(user.email, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text('Registered Member', style: TextStyle(color: Colors.grey.shade600)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Remove Member',
                    onPressed: () {
                      if (libraryData.currentUser?.email == user.email) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cannot delete currently logged in user.')),
                        );
                      } else {
                        libraryData.deleteUser(user.email);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
