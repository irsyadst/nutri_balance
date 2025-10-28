import 'package:flutter/material.dart';
import 'login_screen.dart';
// Import widget baru
import '../widgets/onboarding/onboarding_content.dart'; // Ini sudah ada sebelumnya
import '../widgets/onboarding/page_indicator.dart';
import '../widgets/onboarding/action_buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0; // State untuk halaman aktif

  // Data onboarding (bisa dipindah ke model atau konstanta terpisah)
  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.png", // Pastikan path gambar benar
      "title": "Lacak Nutrisi & Capai Tujuan Sehatmu", // Judul lebih singkat
      "description": "Selamat datang di NutriBalance! Mulai pantau kalori, makro, dan progres target idealmu dengan mudah.",
    },
    {
      "image": "assets/images/onboarding1.png", // Ganti gambar jika ada
      "title": "Rencanakan Menu Harianmu Sendiri",
      "description": "Temukan resep sehat, buat jadwal makan personal, dan capai keseimbangan nutrisi setiap hari.",
    },
    {
      "image": "assets/images/onboarding1.png", // Ganti gambar jika ada
      "title": "Mulai Perjalanan Sehatmu Sekarang!",
      "description": "Siap untuk transformasi? Tekan 'Get Started' untuk mengatur profil dan memulai gaya hidup sehatmu.",
    },
  ];

  @override
  void dispose() { // Jangan lupa dispose PageController
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi untuk navigasi ke halaman login/autentikasi
  void _navigateToAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Fungsi untuk pindah ke halaman berikutnya
  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn, // Gunakan kurva animasi
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Konten Onboarding (PageView)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                // Update _currentPage saat halaman berganti
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  // Gunakan OnboardingPageContent yang sudah ada
                  return OnboardingPageContent(
                    image: onboardingData[index]['image']!,
                    title: onboardingData[index]['title']!,
                    description: onboardingData[index]['description']!,
                    // isLastPage tidak perlu diteruskan ke sini lagi
                  );
                },
              ),
            ),

            // Indikator Halaman dan Tombol Aksi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0), // Sesuaikan padding
              child: Column(
                children: [
                  // Gunakan PageIndicator widget
                  PageIndicator(
                    pageCount: onboardingData.length,
                    currentPage: _currentPage,
                    activeColor: Theme.of(context).primaryColor, // Gunakan warna tema
                    inactiveColor: Colors.grey.shade300, // Warna inactive
                  ),
                  const SizedBox(height: 50), // Jarak antara indikator dan tombol

                  // Gunakan OnboardingActionButtons widget
                  OnboardingActionButtons(
                    isLastPage: _currentPage == onboardingData.length - 1,
                    onSkip: _navigateToAuth, // Langsung ke auth saat skip
                    onContinue: _nextPage, // Pindah halaman saat continue
                    onGetStarted: _navigateToAuth, // Ke auth saat get started
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}