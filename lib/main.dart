import 'package:flutter/material.dart';
import 'views/screens/splash_screen.dart';

void main() {
  runApp(const NutriBalanceApp());
}

class NutriBalanceApp extends StatelessWidget {
  const NutriBalanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriBalance',
      theme: ThemeData(
        // --- UBAH INI UNTUK WARNA BIRU UTAMA ---
        primaryColor: const Color(0xFF007BFF), // Warna biru dari desain
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue) // Fallback untuk beberapa widget
            .copyWith(secondary: const Color(0xFF007BFF)), // Juga set secondary
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: 'Inter', // Contoh font, sesuaikan jika Anda punya
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}