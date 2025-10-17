import 'package:flutter/material.dart';
import 'dart:async';

import '../../models/api_service.dart';
import '../../models/storage_service.dart';
import '../../models/user_model.dart';
import 'login_screen.dart';
import 'main_app_screen.dart';
import 'onboarding_screen.dart';

// SplashScreen sekarang menjadi gerbang utama untuk memeriksa sesi
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memeriksa sesi saat aplikasi dimulai
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Beri sedikit jeda agar splash screen terlihat
    await Future.delayed(const Duration(seconds: 2));

    final storage = StorageService();
    final api = ApiService();

    // 1. Cek apakah ada token yang tersimpan
    final token = await storage.getToken();

    if (token != null) {
      // 2. Jika token ada, validasi token dengan mengambil profil pengguna
      final User? user = await api.getProfile(token);

      if (user != null && mounted) {
        // 3a. Jika profil berhasil didapat, navigasi ke halaman utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainAppScreen(user: user)),
        );
      } else if (mounted) {
        // 3b. Jika profil gagal didapat (token tidak valid), navigasi ke halaman login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else if (mounted) {
      // 4. Jika tidak ada token, navigasi ke alur normal (onboarding)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan UI splash screen tidak berubah
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, color: Color(0xFF82B0F2), size: 80),
            const SizedBox(height: 20),
            const Text(
              'NutriBalance',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D1617)),
            ),
            const SizedBox(height: 8),
            Text(
              'Panduan Cerdas Kalori Harian\ndan Puasa Intermiten Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}