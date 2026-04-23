import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/storage_service.dart';

class BookProvider extends ChangeNotifier {
  List<Book> books = [];
  bool loading = true;

  BookProvider() {
    loadBooks();
  }

  /// LOAD BOOKS FROM LOCAL STORAGE
  void loadBooks() async {
    books = await StorageService.loadBooks();
    loading = false;
    notifyListeners();
  }

  /// ADD BOOK
  void addBook(Book book) {
    books.add(book);
    StorageService.saveBooks(books);
    notifyListeners();
  }

  /// DELETE BOOK
  void deleteBook(int index) {
    books.removeAt(index);
    StorageService.saveBooks(books);
    notifyListeners();
  }

  /// ISSUE / RETURN BOOK
  void toggleIssue(int index) {
    books[index].issued = !books[index].issued;
    StorageService.saveBooks(books);
    notifyListeners();
  }

  /// UPDATE / EDIT BOOK
  void updateBook(int index, Book updatedBook) {
    books[index] = updatedBook;
    StorageService.saveBooks(books);
    notifyListeners();
  }
}
