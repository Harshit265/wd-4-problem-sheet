import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book_model.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();

    if (provider.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF009688)), // Teal
        ),
      );
    }

    if (provider.books.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Library Books")),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.library_books_outlined, size: 100, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "No Books Found",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Library Books"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.books.length,
        itemBuilder: (context, index) {
          final book = provider.books[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              title: Text(
                book.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text("${book.author} • ISBN: ${book.isbn}"),
                  const SizedBox(height: 6),
                  Text("Quantity: ${book.quantity}"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: book.issued ? Colors.orange : const Color(0xFF009688), // Teal
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      book.issued ? "Issued" : "Available",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: book.issued ? "Return Book" : "Issue Book",
                    icon: const Icon(Icons.swap_horiz, color: Colors.blue),
                    onPressed: () {
                      provider.toggleIssue(index);
                    },
                  ),
                  IconButton(
                    tooltip: "Edit Book",
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      showEditDialog(context, index);
                    },
                  ),
                  IconButton(
                    tooltip: "Delete Book",
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      provider.deleteBook(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showEditDialog(BuildContext context, int index) {
    final provider = context.read<BookProvider>();
    final book = provider.books[index];

    final titleController = TextEditingController(text: book.title);
    final authorController = TextEditingController(text: book.author);
    final isbnController = TextEditingController(text: book.isbn);
    final quantityController = TextEditingController(text: book.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Book"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(
                    labelText: "Author",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: isbnController,
                  decoration: const InputDecoration(
                    labelText: "ISBN",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final quantity = int.tryParse(quantityController.text.trim());

                if (titleController.text.trim().isEmpty ||
                    authorController.text.trim().isEmpty ||
                    isbnController.text.trim().isEmpty ||
                    quantity == null ||
                    quantity <= 0) {
                  return;
                }

                provider.updateBook(
                  index,
                  Book(
                    title: titleController.text.trim(),
                    author: authorController.text.trim(),
                    isbn: isbnController.text.trim(),
                    quantity: quantity,
                    issued: book.issued,
                  ),
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009688), // Teal
                foregroundColor: Colors.white,
              ),
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
