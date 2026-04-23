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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(book == null ? 'Add New Book' : 'Edit Book', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Book Title', prefixIcon: Icon(Icons.book_outlined)),
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: authorController,
                    decoration: const InputDecoration(labelText: 'Author Name', prefixIcon: Icon(Icons.person_outline)),
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: isbnController,
                    decoration: const InputDecoration(labelText: 'ISBN', prefixIcon: Icon(Icons.qr_code)),
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Total Quantity', prefixIcon: Icon(Icons.numbers)),
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
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
              child: Text(book == null ? 'Add Book' : 'Save Changes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Manage Books', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBookDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
      body: ListenableBuilder(
        listenable: libraryData,
        builder: (context, child) {
          if (libraryData.books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('No books cataloged yet.', style: TextStyle(color: Colors.grey.shade600, fontSize: 18)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: libraryData.books.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final book = libraryData.books[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: book.availableQuantity > 0 ? Colors.green.shade50 : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              book.availableQuantity > 0 ? Icons.check_circle : Icons.watch_later,
                              color: book.availableQuantity > 0 ? Colors.green : Colors.orange,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('By ${book.author}', style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
                                const SizedBox(height: 4),
                                Text('ISBN: ${book.isbn}', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                            onPressed: () => _showBookDialog(book),
                            tooltip: 'Edit Book',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            tooltip: 'Delete Book',
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
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildStatusChip('Total: ${book.quantity}', Colors.blue),
                              const SizedBox(width: 8),
                              _buildStatusChip('Available: ${book.availableQuantity}', Colors.green),
                              const SizedBox(width: 8),
                              _buildStatusChip('Issued: ${book.issuedQuantity}', Colors.orange),
                            ],
                          ),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: book.issuedQuantity > 0 ? () => libraryData.returnBook(book.id) : null,
                                icon: const Icon(Icons.keyboard_return, size: 18),
                                label: const Text('Return'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: book.availableQuantity > 0 ? () => libraryData.issueBook(book.id) : null,
                                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
                                icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                                label: const Text('Issue'),
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

  Widget _buildStatusChip(String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.shade200),
      ),
      child: Text(label, style: TextStyle(color: color.shade700, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
