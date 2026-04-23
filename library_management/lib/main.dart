import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home.dart';
import 'screens/books.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/members.dart';
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
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1), // Modern Indigo
              brightness: Brightness.light,
              surfaceTint: Colors.transparent,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              scrolledUnderElevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 8,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: libraryData.currentUser == null ? '/login' : '/home',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/books': (context) => const BooksScreen(),
            '/members': (context) => const MembersScreen(),
          },
        );
      }
    );
  }
}
