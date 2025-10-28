import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import jika logo SVG

// Widget untuk menampilkan konten visual Splash Screen
class SplashContent extends StatelessWidget {
  // Path ke aset logo (bisa SVG atau PNG)
  final String logoAssetPath;
  final String title;
  final String subtitle;

  const SplashContent({
    super.key,
    required this.logoAssetPath, // Contoh: 'assets/images/NutriBalance.png' atau '.svg'
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    bool isSvg = logoAssetPath.toLowerCase().endsWith('.svg');
    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          isSvg
              ? SvgPicture.asset(
            logoAssetPath,
            height: 80, // Sesuaikan ukuran
            placeholderBuilder: (context) => const SizedBox(height: 80), // Placeholder
          )
              : Image.asset(
            logoAssetPath,
            height: 80, // Sesuaikan ukuran
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.image_not_supported, size: 80, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20), // Jarak logo ke judul

          // Judul Aplikasi
          Text(
            title,
            style: const TextStyle(
              fontSize: 28, // Ukuran font judul
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10), // Jarak judul ke subtitle

          // Subtitle/Tagline
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.5, // Jarak antar baris subtitle
            ),
          ),
          const SizedBox(height: 60), // Jarak ke loading indicator

          // Loading Indicator
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor), // Warna dari tema
              strokeWidth: 4,
              backgroundColor: primaryColor.withOpacity(0.2), // Warna background indicator
            ),
          ),
        ],
      ),
    );
  }
}