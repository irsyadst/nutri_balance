import 'dart:ui'; // Untuk ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Jika logo SVG

class LoadingModal extends StatelessWidget {
  final String message;
  final String? logoAssetPath;

  const LoadingModal({
    super.key,
    required this.message,
    this.logoAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (logoAssetPath != null) ...[
                    logoAssetPath!.toLowerCase().endsWith('.svg')
                        ? SvgPicture.asset(logoAssetPath!, height: 50)
                        : Image.asset(logoAssetPath!, height: 50),
                    const SizedBox(height: 25),
                  ] else ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
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