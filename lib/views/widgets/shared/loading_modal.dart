import 'dart:ui'; // Untuk ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Jika logo SVG

class LoadingModal extends StatelessWidget {
  final String message;
  final String? logoAssetPath; // Path logo opsional

  const LoadingModal({
    super.key,
    required this.message,
    this.logoAssetPath, // Contoh: 'assets/images/NutriBalance.png'
  });

  @override
  Widget build(BuildContext context) {
    // PopScope untuk mencegah back button menutup modal secara tidak sengaja
    return PopScope(
      canPop: false, // User tidak bisa menutup modal dengan back button
      child: Stack(
        children: [
          // Background blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.3), // Background semi-transparan
            ),
          ),
          // Konten Modal di tengah
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30), // Sesuaikan padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ukuran modal sesuai konten
                children: [
                  // Tampilkan logo jika path diberikan
                  if (logoAssetPath != null) ...[
                    // Cek apakah SVG atau PNG
                    logoAssetPath!.toLowerCase().endsWith('.svg')
                        ? SvgPicture.asset(logoAssetPath!, height: 50)
                        : Image.asset(logoAssetPath!, height: 50),
                    const SizedBox(height: 25),
                  ] else ...[
                    // Tampilkan CircularProgressIndicator jika tidak ada logo
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                  ],
                  // Pesan Loading
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17, // Sedikit lebih kecil
                      fontWeight: FontWeight.w500, // Tidak terlalu tebal
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}