import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

// Halaman 1: Splash Screen (View)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, color: Color(0xFF82B0F2), size: 80),
            const SizedBox(height: 20),
            const Text('NutriBalance', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D1617))),
            const SizedBox(height: 8),
            Text('Panduan Cerdas Kalori Harian\ndan Puasa Intermiten Anda.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
