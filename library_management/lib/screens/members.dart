import 'package:flutter/material.dart';
import '../data.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Members (Users)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListenableBuilder(
        listenable: libraryData,
        builder: (context, child) {
          if (libraryData.users.isEmpty) {
            return const Center(child: Text('No members available.'));
          }
          return ListView.builder(
            itemCount: libraryData.users.length,
            itemBuilder: (context, index) {
              final user = libraryData.users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Text(
                      user.email.isNotEmpty ? user.email[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white)
                    ),
                  ),
                  title: Text(user.email, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Registered Member'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
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
