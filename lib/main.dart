import 'package:flutter/material.dart';
import 'views/screens/splash_screen.dart';

// Titik masuk utama aplikasi Anda.
void main() {
  runApp(const NutriBalanceApp());
}

// Widget root dari aplikasi.
class NutriBalanceApp extends StatelessWidget {
  const NutriBalanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriBalance MVC',
      theme: ThemeData(
        primaryColor: const Color(0xFF82B0F2),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF82B0F2)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // Aplikasi dimulai dari SplashScreen
      home: const SplashScreen(),
    );
  }
}
