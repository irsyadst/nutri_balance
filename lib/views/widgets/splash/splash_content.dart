import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SplashContent extends StatelessWidget {
  final String logoAssetPath;
  final String title;
  final String subtitle;

  const SplashContent({
    super.key,
    required this.logoAssetPath,
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
          isSvg
              ? SvgPicture.asset(
            logoAssetPath,
            height: 80,
            placeholderBuilder: (context) => const SizedBox(height: 80),
          )
              : Image.asset(
            logoAssetPath,
            height: 80,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.image_not_supported, size: 80, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 60),

          // Loading Indicator
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              strokeWidth: 4,
              backgroundColor: primaryColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}