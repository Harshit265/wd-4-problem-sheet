import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/books.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await libraryData.init();
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: libraryData,
      builder: (context, child) {
        return MaterialApp(
          title: 'Library Management',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: libraryData.currentUser == null ? '/login' : '/home',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/books': (context) => const BooksScreen(),
          },
        );
      }
    );
  }
}
