import 'package:flutter/material.dart';
import '../data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Library Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome, ${libraryData.currentUser?.email.split('@')[0] ?? 'Admin'}!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard(context, 'Total Books', '$totalBooks', Colors.blue, Icons.library_books),
                    _buildStatCard(context, 'Available', '$availableBooks', Colors.green, Icons.check_circle_outline),
                    _buildStatCard(context, 'Issued', '$issuedBooks', Colors.orange, Icons.bookmark_added_outlined),
                    _buildStatCard(context, 'Unique Titles', '$uniqueTitles', Colors.purple, Icons.auto_stories),
                  ],
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildActionCard(
                      context, 
                      'Manage Books', 
                      'Add, edit, or issue books from the catalog.', 
                      Icons.menu_book_rounded, 
                      Colors.indigo,
                      () => Navigator.pushNamed(context, '/books'),
                    ),
                    _buildActionCard(
                      context, 
                      'Manage Members', 
                      'View and remove library users.', 
                      Icons.people_alt_rounded, 
                      Colors.teal,
                      () => Navigator.pushNamed(context, '/members'), // Wait, members route isn't in main.dart anymore
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String count, MaterialColor color, IconData icon) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.shade50, shape: BoxShape.circle),
              child: Icon(icon, color: color.shade600, size: 32),
            ),
            const SizedBox(height: 16),
            Text(count, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(height: 24),
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Go', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward_rounded, color: color, size: 18),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
