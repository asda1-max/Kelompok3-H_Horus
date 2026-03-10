// ============================================================
// main.dart - Entry point aplikasi Horus
// File ini mengatur tema global dan navigasi awal ke LoginPage
// ============================================================

import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const HorusApp());
}

/// Widget utama aplikasi
class HorusApp extends StatelessWidget {
  const HorusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horus App',
      debugShowCheckedModeBanner: false, // Hilangkan banner debug

      // ---- Tema global aplikasi ----
      theme: ThemeData(
        // Warna utama menggunakan seed color biru tua
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Gunakan Material Design 3

        // Tema AppBar
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),

        // Tema Card
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Tema Input Field
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),

        // Tema Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      // Halaman awal = Login
      home: const LoginPage(),
    );
  }
}
