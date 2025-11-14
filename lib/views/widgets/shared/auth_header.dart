import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? logoAssetPath;
  final double logoHeight;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoAssetPath,
    this.logoHeight = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    bool isSvg = logoAssetPath?.toLowerCase().endsWith('.svg') ?? false;

    return Column(
      children: [
        if (logoAssetPath != null) ...[
          Center(
            child: isSvg
                ? SvgPicture.asset(
              logoAssetPath!,
              height: logoHeight,
              placeholderBuilder: (context) => SizedBox(height: logoHeight),
            )
                : Image.asset(
              logoAssetPath!,
              height: logoHeight,
              // Error handling for PNG/other image types
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported,
                size: logoHeight,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
        // Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 15),
        // Subtitle
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}