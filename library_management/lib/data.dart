import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class LibraryData extends ChangeNotifier {
  List<Book> books = [];
  List<User> users = [];
  User? currentUser;

  bool isLoaded = false;

  LibraryData();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    final booksJson = prefs.getString('books');
    if (booksJson != null) {
      Iterable l = json.decode(booksJson);
      books = List<Book>.from(l.map((model) => Book.fromJson(model)));
    }

    final usersJson = prefs.getString('users');
    if (usersJson != null) {
      Iterable l = json.decode(usersJson);
      users = List<User>.from(l.map((model) => User.fromJson(model)));
    }

    final currentUserJson = prefs.getString('currentUser');
    if (currentUserJson != null) {
      currentUser = User.fromJson(json.decode(currentUserJson));
    }
    
    isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('books', json.encode(books.map((b) => b.toJson()).toList()));
    prefs.setString('users', json.encode(users.map((u) => u.toJson()).toList()));
    if (currentUser != null) {
      prefs.setString('currentUser', json.encode(currentUser!.toJson()));
    } else {
      prefs.remove('currentUser');
    }
  }

  Future<String?> register(String email, String password) async {
    if (users.any((u) => u.email == email)) {
      return 'Email already registered';
    }
    users.add(User(email: email, passwordHash: User.hashPassword(password)));
    await _saveData();
    notifyListeners();
    return null; // Success
  }

  Future<String?> login(String email, String password) async {
    final hash = User.hashPassword(password);
    try {
      final user = users.firstWhere((u) => u.email == email && u.passwordHash == hash);
      currentUser = user;
      await _saveData();
      notifyListeners();
      return null; // Success
    } catch (e) {
      return 'Invalid email or password';
    }
  }

  Future<void> logout() async {
    currentUser = null;
    await _saveData();
    notifyListeners();
  }

  Future<void> addBook(String title, String author, String isbn, int quantity) async {
    books.add(Book(
      id: 'B${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      author: author,
      isbn: isbn,
      quantity: quantity,
    ));
    await _saveData();
    notifyListeners();
  }

  Future<void> updateBook(String id, String title, String author, String isbn, int quantity) async {
    var book = books.firstWhere((b) => b.id == id);
    book.title = title;
    book.author = author;
    book.isbn = isbn;
    book.quantity = quantity;
    await _saveData();
    notifyListeners();
  }

  Future<void> deleteBook(String id) async {
    books.removeWhere((b) => b.id == id);
    await _saveData();
    notifyListeners();
  }

  Future<void> issueBook(String bookId) async {
    var book = books.firstWhere((b) => b.id == bookId);
    if (book.availableQuantity > 0) {
      book.issuedQuantity++;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> returnBook(String bookId) async {
    var book = books.firstWhere((b) => b.id == bookId);
    if (book.issuedQuantity > 0) {
      book.issuedQuantity--;
      await _saveData();
      notifyListeners();
    }
  }
}

final libraryData = LibraryData();
