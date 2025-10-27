import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

// --- Import yang Diperlukan ---
import '../../models/storage_service.dart';
import '../../models/api_service.dart';
import '../../models/user_model.dart';

import 'onboarding_screen.dart';
import 'main_app_screen.dart';
import 'questionnaire_screen.dart';
// --- Akhir Import ---

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Hapus timer lama
  // Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Ganti timer dengan pengecekan sesi
    _checkSession();
  }

  // --- Fungsi Baru untuk Cek Sesi ---
  void _checkSession() async {
    // Beri sedikit delay agar splash screen terlihat (opsional)
    await Future.delayed(const Duration(seconds: 2));

    final storageService = StorageService();
    final apiService = ApiService(); // Idealnya instance ini didapat dari dependency injection/service locator

    final token = await storageService.getToken(); // Coba ambil token

    if (token != null) {
      // Jika token ada, coba ambil profil
      print("Token found, trying to get profile...");
      final User? user = await apiService.getProfile(token);

      if (user != null && mounted) {
        // Jika profil berhasil didapat
        print("Profile fetched successfully for ${user.name}");
        if (user.profile != null) {
          // Jika profil lengkap, navigasi ke MainAppScreen
          print("Profile complete, navigating to MainAppScreen");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainAppScreen(user: user)),
          );
        } else {
          // Jika profil belum lengkap, navigasi ke QuestionnaireScreen
          print("Profile incomplete, navigating to QuestionnaireScreen");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
          );
        }
      } else if (mounted) {
        // Jika token ada tapi profil gagal didapat (token invalid/expired)
        print("Failed to fetch profile with token, navigating to OnboardingScreen");
        await storageService.deleteToken(); // Hapus token yang tidak valid
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()), // Kembali ke onboarding/login
        );
      }
    } else if (mounted) {
      // Jika token tidak ada
      print("No token found, navigating to OnboardingScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()), // Ke onboarding/login
      );
    }
  }
  // --- Akhir Fungsi Cek Sesi ---


  @override
  Widget build(BuildContext context) {
    // UI Splash Screen (tidak perlu diubah)
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/NutriBalance.png',
              height: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'NutriBalance',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Panduan Cerdas Kalori Harian\ndan Puasa Intermiten Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 80),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                strokeWidth: 4,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}