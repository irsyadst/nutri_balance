import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final Color activeColor;
  final Color inactiveColor;
  final double dotWidth;
  final double activeDotWidth;
  final double dotHeight;
  final double spacing;

  const PageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    required this.activeColor,
    this.inactiveColor = Colors.grey, // Warna default untuk titik tidak aktif
    this.dotWidth = 8.0,
    this.activeDotWidth = 24.0,
    this.dotHeight = 8.0,
    this.spacing = 5.0, // Jarak antar titik
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Pusatkan indikator
      children: List.generate(pageCount, (index) => _buildDot(index)),
    );
  }

  // Helper internal untuk membuat satu titik
  Widget _buildDot(int index) {
    bool isActive = currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200), // Durasi animasi
      height: dotHeight,
      // Lebar berbeda untuk titik aktif dan tidak aktif
      width: isActive ? activeDotWidth : dotWidth,
      margin: EdgeInsets.only(right: spacing), // Jarak antar titik
      decoration: BoxDecoration(
        // Bentuk rounded
        borderRadius: BorderRadius.circular(dotHeight / 2), // Setengah tinggi untuk lingkaran/pil
        // Warna berbeda untuk titik aktif dan tidak aktif
        color: isActive ? activeColor : inactiveColor.withOpacity(0.5), // Buat inactive lebih transparan
      ),
    );
  }
}