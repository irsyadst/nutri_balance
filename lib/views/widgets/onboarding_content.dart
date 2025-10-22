import 'package:flutter/material.dart';

class OnboardingPageContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool isLastPage; // Parameter baru untuk menentukan halaman terakhir

  const OnboardingPageContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.isLastPage = false, // Defaultnya bukan halaman terakhir
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan radius berdasarkan isLastPage
    final Radius defaultRadius = const Radius.circular(50);
    final Radius zeroRadius = Radius.zero;

    final BorderRadius backgroundBorderRadius = isLastPage
        ? BorderRadius.only(
            topLeft: defaultRadius,    // Tetap melengkung di kiri atas area putih
            topRight: defaultRadius,   // Tetap melengkung di kanan atas area putih
            bottomLeft: zeroRadius,    // Datar di kiri bawah
            bottomRight: zeroRadius,   // Datar di kanan bawah
          )
        : BorderRadius.only(
            bottomLeft: defaultRadius,  // Melengkung di kiri bawah area biru
            bottomRight: defaultRadius, // Melengkung di kanan bawah area biru
          );

    return Column(
      children: [
        // Bagian atas: Latar belakang biru dengan atau tanpa lengkungan
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF007BFF), // Warna biru
              borderRadius: backgroundBorderRadius, // Terapkan radius yang berbeda
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        
        // Bagian bawah: Konten teks di latar belakang putih
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white, // Latar belakang putih
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}