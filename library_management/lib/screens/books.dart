import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data.dart';
import '../models.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  void _showBookDialog([Book? book]) {
    final titleController = TextEditingController(text: book?.title ?? '');
    final authorController = TextEditingController(text: book?.author ?? '');
    final isbnController = TextEditingController(text: book?.isbn ?? '');
    final quantityController = TextEditingController(text: book != null ? book.quantity.toString() : '1');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(book == null ? 'Add New Book' : 'Edit Book'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Book Title'),
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: authorController,
                    decoration: const InputDecoration(labelText: 'Author Name'),
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: isbnController,
                    decoration: const InputDecoration(labelText: 'ISBN'),
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Total Quantity'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (val) {
                      if (val!.isEmpty) return 'Required';
                      int? q = int.tryParse(val);
                      if (q == null || q < 1) return 'Must be >= 1';
                      if (book != null && q < book.issuedQuantity) return 'Cannot be less than issued';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  int quantity = int.parse(quantityController.text);
                  if (book == null) {
                    libraryData.addBook(
                      titleController.text,
                      authorController.text,
                      isbnController.text,
                      quantity,
                    );
                  } else {
                    libraryData.updateBook(
                      book.id,
                      titleController.text,
                      authorController.text,
                      isbnController.text,
                      quantity,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(book == null ? 'Add' : 'Save'),
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
        title: const Text('Manage Books'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookDialog(),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: libraryData,
        builder: (context, child) {
          if (libraryData.books.isEmpty) {
            return const Center(child: Text('No books available.'));
          }
          return ListView.builder(
            itemCount: libraryData.books.length,
            itemBuilder: (context, index) {
              final book = libraryData.books[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              book.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showBookDialog(book),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  if (book.issuedQuantity > 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Cannot delete book with issued copies.')),
                                    );
                                  } else {
                                    await libraryData.deleteBook(book.id);
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      Text('Author: ${book.author} | ISBN: ${book.isbn}'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total: ${book.quantity}  |  Available: ${book.availableQuantity}  |  Issued: ${book.issuedQuantity}'),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: book.availableQuantity > 0 ? () => libraryData.issueBook(book.id) : null,
                                child: const Text('Issue'),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: book.issuedQuantity > 0 ? () => libraryData.returnBook(book.id) : null,
                                child: const Text('Return'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
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
