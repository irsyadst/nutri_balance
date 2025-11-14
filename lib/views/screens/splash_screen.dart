// lib/views/screens/splash_screen.dart
import 'package:flutter/material.dart';
import '../../controllers/splash_controller.dart';
import 'onboarding_screen.dart';
import 'main_app_screen.dart';
import 'questionnaire_screen.dart';

import '../widgets/splash/splash_content.dart';


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
    _controller = SplashController();
    _controller.addListener(_handleNavigation);
  }

  void _handleNavigation() {
    if (!mounted) return;

    switch (_controller.status) {
      case SplashStatus.authenticated:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainAppScreen(user: _controller.user!)),
        );
        break;
      case SplashStatus.needsProfile:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
        );
        break;
      case SplashStatus.unauthenticated:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
        break;
      case SplashStatus.failure:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_controller.errorMessage ?? 'Terjadi kesalahan')),
        );
        break;
      case SplashStatus.loading:
      break;
    }
  }



  @override
  void dispose() {
    _controller.removeListener(_handleNavigation);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SplashContent(
        logoAssetPath: 'assets/images/NutriBalance.png',
        title: 'NutriBalance',
        subtitle: 'Panduan Cerdas Kalori Harian\ndan Puasa Intermiten Anda.',
      ),
    );
  }
}