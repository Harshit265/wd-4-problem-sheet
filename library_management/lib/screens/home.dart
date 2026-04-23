import 'package:flutter/material.dart';
import '../data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await libraryData.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          )
        ],
      ),
      body: ListenableBuilder(
        listenable: libraryData,
        builder: (context, child) {
          int totalBooks = libraryData.books.fold(0, (sum, b) => sum + b.quantity);
          int issuedBooks = libraryData.books.fold(0, (sum, b) => sum + b.issuedQuantity);
          int availableBooks = totalBooks - issuedBooks;
          int uniqueTitles = libraryData.books.length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildStatCard(context, 'Total Books', '$totalBooks', Colors.blue)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard(context, 'Available', '$availableBooks', Colors.green)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStatCard(context, 'Issued', '$issuedBooks', Colors.orange)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard(context, 'Unique Titles', '$uniqueTitles', Colors.purple)),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/books'),
                  icon: const Icon(Icons.book),
                  label: const Text('Manage Books'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String count, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
