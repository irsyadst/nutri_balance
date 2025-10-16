import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../widgets/onboarding_content.dart';

// Halaman 2: Onboarding (View)
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {"title": "Capai Versi Terbaik Dirimu", "description": "Selamat datang di NutriBalance, solusi lengkap Badan Ideal Anda."},
    {"title": "Lacak Kemajuan Anda", "description": "Lacak kemajuan puasa, asupan air, berat badan, dan suasana hati Anda."},
    {"title": "Capai Tujuan Puasa Anda", "description": "Tingkatkan perjalanan puasa Anda dengan fitur gamifikasi NutriBalance."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: onboardingData.length,
              itemBuilder: (context, index) => OnboardingPageContent(
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
              ),
            ),
            Positioned(
              bottom: 40, left: 30, right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _navigateToAuth(),
                    child: const Text('Skip', style: TextStyle(color: Colors.grey)),
                  ),
                  Row(
                    children: List.generate(onboardingData.length, (index) => _buildDot(index)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < onboardingData.length - 1) {
                        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                      } else {
                        _navigateToAuth();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(), padding: const EdgeInsets.all(15),
                      backgroundColor: const Color(0xFF82B0F2),
                    ),
                    child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAuth() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 8, width: _currentPage == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index ? const Color(0xFF82B0F2) : Colors.grey[300],
      ),
    );
  }
}