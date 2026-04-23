import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  String email;
  String passwordHash;

  User({required this.email, required this.passwordHash});

  Map<String, dynamic> toJson() => {
        'email': email,
        'passwordHash': passwordHash,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'],
        passwordHash: json['passwordHash'],
      );

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}

class Book {
  String id;
  String title;
  String author;
  String isbn;
  int quantity;
  int issuedQuantity;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.quantity,
    this.issuedQuantity = 0,
  });

  int get availableQuantity => quantity - issuedQuantity;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'isbn': isbn,
        'quantity': quantity,
        'issuedQuantity': issuedQuantity,
      };

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        isbn: json['isbn'],
        quantity: json['quantity'],
        issuedQuantity: json['issuedQuantity'] ?? 0,
      );
}
