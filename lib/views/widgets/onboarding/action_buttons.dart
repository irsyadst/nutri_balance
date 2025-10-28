import 'package:flutter/material.dart';

// Widget untuk menampilkan tombol aksi di bagian bawah layar onboarding
class OnboardingActionButtons extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onSkip; // Callback saat tombol Skip ditekan
  final VoidCallback onContinue; // Callback saat tombol Continue ditekan
  final VoidCallback onGetStarted; // Callback saat tombol Get Started (di halaman terakhir) ditekan

  const OnboardingActionButtons({
    super.key,
    required this.isLastPage,
    required this.onSkip,
    required this.onContinue,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor; // Ambil warna primer dari tema

    // Tampilkan tombol berbeda berdasarkan apakah ini halaman terakhir
    return isLastPage
        ? _buildFullWidthButton(
      context: context,
      text: 'Get Started', // Teks untuk halaman terakhir
      onPressed: onGetStarted,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    )
        : _buildDualButtons(
      context: context,
      primaryColor: primaryColor,
    );
  }

  // Helper untuk membangun dua tombol (Skip dan Continue)
  Widget _buildDualButtons({required BuildContext context, required Color primaryColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tombol Skip
        Expanded(
          child: TextButton(
            onPressed: onSkip, // Gunakan callback onSkip
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600, // Warna teks
              backgroundColor: Colors.grey.shade200, // Warna background
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Bentuk rounded
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Skip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16), // Jarak antar tombol
        // Tombol Continue
        Expanded(
          child: ElevatedButton(
            onPressed: onContinue, // Gunakan callback onContinue
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor, // Warna primer
              foregroundColor: Colors.white, // Warna teks
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Bentuk rounded
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // Helper untuk membangun satu tombol lebar penuh
  Widget _buildFullWidthButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color foregroundColor}) {
    return SizedBox(
      width: double.infinity, // Lebar penuh
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Bentuk rounded
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}