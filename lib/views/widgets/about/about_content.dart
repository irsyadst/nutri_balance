// lib/views/widgets/about/about_content.dart

import 'package:flutter/material.dart';

class AboutContent extends StatelessWidget {
  final String version;

  const AboutContent({
    super.key,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/NutriBalance.png',
            height: 100,
          ),
          const SizedBox(height: 16),
          const Text(
            'NutriBalance',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            version,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          const Text(
            'NutriBalance adalah aplikasi pelacak kalori dan nutrisi yang dirancang untuk membantu Anda mencapai target kesehatan dengan lebih mudah. Catat makanan, pantau progres, dan dapatkan rekomendasi menu harian yang dipersonalisasi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          const Text(
            '© 2025 NutriBalance. All rights reserved.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}