import 'package:flutter/material.dart';
// Hapus import SVG jika tidak digunakan langsung di sini
// import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async'; // Tetap diperlukan untuk Future.delayed

// --- Import yang Diperlukan ---
import '../../models/storage_service.dart';
import '../../models/api_service.dart';
import '../../models/user_model.dart';
// Import screen tujuan
import 'onboarding_screen.dart';
import 'main_app_screen.dart';
import 'questionnaire_screen.dart';
// Import widget UI splash
import '../widgets/splash/splash_content.dart';
// --- Akhir Import ---

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Timer tidak digunakan lagi
  // Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkSession(); // Langsung panggil pengecekan sesi
  }

  // --- Fungsi Cek Sesi (Logika Tetap di Screen) ---
  void _checkSession() async {
    // Beri sedikit delay agar splash screen terlihat
    await Future.delayed(const Duration(seconds: 2));

    // Pastikan widget masih mounted sebelum melanjutkan
    if (!mounted) return;

    final storageService = StorageService();
    // Idealnya ApiService didapat dari dependency injection
    final apiService = ApiService();

    final token = await storageService.getToken();

    User? user; // Variabel untuk menyimpan data user jika berhasil fetch

    if (token != null) {
      print("Token found, trying to get profile...");
      user = await apiService.getProfile(token); // Coba fetch profil
    }

    // --- Navigasi (Pastikan cek mounted lagi sebelum navigasi) ---
    if (!mounted) return; // Cek mounted lagi setelah await

    if (user != null) {
      // Jika user berhasil didapatkan (token valid & profil ada)
      print("Profile fetched successfully for ${user.name}");
      if (user.profile != null) {
        // Jika profil lengkap -> MainAppScreen
        print("Profile complete, navigating to MainAppScreen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainAppScreen(user: user!)),
        );
      } else {
        // Jika profil belum lengkap -> QuestionnaireScreen
        print("Profile incomplete, navigating to QuestionnaireScreen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
        );
      }
    } else {
      // Jika token tidak ada ATAU token invalid (fetch profile gagal)
      if (token != null) {
        print("Failed to fetch profile with token, deleting invalid token.");
        await storageService.deleteToken(); // Hapus token invalid
      }
      print("Navigating to OnboardingScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }
  // --- Akhir Fungsi Cek Sesi ---


  @override
  Widget build(BuildContext context) {
    // UI Splash Screen menggunakan widget SplashContent
    return const Scaffold(
      backgroundColor: Colors.white,
      // Gunakan widget SplashContent untuk menampilkan UI
      body: SplashContent(
        logoAssetPath: 'assets/images/NutriBalance.png', // Sesuaikan path logo
        title: 'NutriBalance',
        subtitle: 'Panduan Cerdas Kalori Harian\ndan Puasa Intermiten Anda.',
      ),
    );
  }
}