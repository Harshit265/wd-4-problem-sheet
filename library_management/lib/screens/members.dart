import 'package:flutter/material.dart';
import '../data.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Member Name'),
              ),
              TextField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact / Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _contactController.text.isNotEmpty) {
                  libraryData.addMember(_nameController.text, _contactController.text);
                  _nameController.clear();
                  _contactController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Members'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMemberDialog,
        child: const Icon(Icons.person_add),
      ),
      body: ListenableBuilder(
        listenable: libraryData,
        builder: (context, child) {
          if (libraryData.members.isEmpty) {
            return const Center(child: Text('No members available.'));
          }
          return ListView.builder(
            itemCount: libraryData.members.length,
            itemBuilder: (context, index) {
              final member = libraryData.members[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Text(
                      member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white)
                    ),
                  ),
                  title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(member.contact),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Optionally check if member has issued books before deleting.
                      bool hasBooks = libraryData.books.any((b) => b.issuedTo == member.id);
                      if (hasBooks) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cannot delete member with issued books.')),
                        );
                      } else {
                        libraryData.deleteMember(member.id);
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
