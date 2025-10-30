// lib/views/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async'; // Tetap diperlukan jika ada logic error/delay

// --- Import yang Diperlukan ---
// Hapus import service/model yang tidak perlu lagi di view
// import '../../models/storage_service.dart';
// import '../../models/api_service.dart';
// import '../../models/user_model.dart';
import '../../controllers/splash_controller.dart'; // Import controller baru
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
  late SplashController _controller;

  @override
  void initState() {
    super.initState();
    // 1. Inisialisasi controller
    _controller = SplashController();
    // 2. Tambahkan listener untuk bereaksi terhadap perubahan status
    _controller.addListener(_handleNavigation);
  }

  // 3. Buat fungsi listener untuk menangani navigasi
  void _handleNavigation() {
    // Pastikan widget masih mounted sebelum navigasi
    if (!mounted) return;

    switch (_controller.status) {
      case SplashStatus.authenticated:
      // Profil lengkap -> MainAppScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainAppScreen(user: _controller.user!)),
        );
        break;
      case SplashStatus.needsProfile:
      // Profil belum lengkap -> QuestionnaireScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
        );
        break;
      case SplashStatus.unauthenticated:
      // Token tidak ada ATAU token invalid -> OnboardingScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
        break;
      case SplashStatus.failure:
      // Opsional: Tampilkan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_controller.errorMessage ?? 'Terjadi kesalahan')),
        );
        // Anda bisa tambahkan tombol "Coba Lagi" di sini jika mau
        break;
      case SplashStatus.loading:
      // Biarkan splash screen tetap tampil
      default:
        break;
    }
  }

  // --- Fungsi Cek Sesi (Logika telah dipindah ke Controller) ---
  // void _checkSession() async { ... } // <-- DIHAPUS

  @override
  void dispose() {
    // 4. Hapus listener dan dispose controller
    _controller.removeListener(_handleNavigation);
    _controller.dispose();
    super.dispose();
  }

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