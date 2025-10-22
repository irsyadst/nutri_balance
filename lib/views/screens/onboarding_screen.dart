import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../widgets/onboarding_content.dart';

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
      "title": "NutriBalance - Capai Versi Terbaik Dirimu, Satu Langkah Setiap Hari.",
      "description": "Selamat datang di NutriBalance, solusi lengkap Badan Ideal Anda, mari kita mulai perjalanan menuju kesehatan dan kesejahteraan yang lebih baik.",
    },
    {
      "image": "assets/images/onboarding1.png", 
      "title": "Lacak kemajuan Anda dan tetap termotivasi",
      "description": "lacak kemajuan puasa, asupan air, berat badan, dan suasana hati Anda dengan pelacak intuitif kami. dapatkan wawasan berharga tentang kebiasaan Anda!.",
    },
    {
      "image": "assets/images/onboarding1.png", 
      "title": "Capai tujuan puasa Anda dengan NutriBalance sekarang",
      "description": "tingkatkan perjalanan puasa Anda dengan fitur gamifikasi nutribalance. dengan NutriBalance, tetap konsisten dan antusias hanya dengan satu ketukan.",
    },
  ];

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
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPageContent(
                    image: onboardingData[index]['image']!,
                    title: onboardingData[index]['title']!,
                    description: onboardingData[index]['description']!,
                    // --- PERUBAHAN DI SINI: kirim isLastPage ---
                    isLastPage: index == onboardingData.length - 1, 
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingData.length, (index) => _buildDot(index)),
                  ),
                  const SizedBox(height: 50),
                  _currentPage == onboardingData.length - 1
                      ? _buildFullWidthButton()
                      : _buildDualButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Fungsi _buildDualButtons, _buildFullWidthButton, _navigateToAuth, _buildDot tetap sama ---
  Widget _buildDualButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            onPressed: _navigateToAuth,
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Skip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF), // Warna biru
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildFullWidthButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _navigateToAuth,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007BFF), // Warna biru
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _navigateToAuth() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index ? const Color(0xFF007BFF) : Colors.grey[300],
      ),
    );
  }
}