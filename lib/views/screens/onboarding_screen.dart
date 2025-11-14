import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../widgets/onboarding/onboarding_content.dart';
import '../widgets/onboarding/page_indicator.dart';
import '../widgets/onboarding/action_buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Lacak Nutrisi & Capai Tujuan Sehatmu",
      "description": "Selamat datang di NutriBalance! Mulai pantau kalori, makro, dan progres target idealmu dengan mudah.",
    },
    {
      "image": "assets/images/onboarding1.png",
      "title": "Rencanakan Menu Harianmu Sendiri",
      "description": "Temukan resep sehat, buat jadwal makan personal, dan capai keseimbangan nutrisi setiap hari.",
    },
    {
      "image": "assets/images/onboarding1.png",
      "title": "Mulai Perjalanan Sehatmu Sekarang!",
      "description": "Siap untuk transformasi? Tekan 'Get Started' untuk mengatur profil dan memulai gaya hidup sehatmu.",
    },
  ];

  @override
  void dispose() {
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

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0), // Sesuaikan padding
              child: Column(
                children: [
                  PageIndicator(
                    pageCount: onboardingData.length,
                    currentPage: _currentPage,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 50),

                  OnboardingActionButtons(
                    isLastPage: _currentPage == onboardingData.length - 1,
                    onSkip: _navigateToAuth,
                    onContinue: _nextPage,
                    onGetStarted: _navigateToAuth,
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