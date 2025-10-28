import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SVG

// Widget Tombol untuk Social Sign In (Google, dll.)
class SocialSignInButton extends StatelessWidget {
  final String label;
  final String iconAssetPath; // Path ke aset SVG atau PNG
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  const SocialSignInButton({
    super.key,
    required this.label,
    required this.iconAssetPath,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black87,
    this.borderColor = const Color(0xFFDDDDDD), // Warna border abu-abu
  });

  @override
  Widget build(BuildContext context) {
    bool isSvg = iconAssetPath.toLowerCase().endsWith('.svg');

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: isSvg
          ? SvgPicture.asset(iconAssetPath, height: 22)
          : Image.asset(iconAssetPath, height: 22), // Tampilkan PNG jika bukan SVG
      label: Text(
        label,
        style: TextStyle(color: foregroundColor, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor, // Warna ripple effect
        elevation: 0, // Tanpa shadow
        side: BorderSide(color: borderColor, width: 1.5), // Border
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 50), // Lebar penuh
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Sesuaikan radius
        ),
      ),
    );
  }
}