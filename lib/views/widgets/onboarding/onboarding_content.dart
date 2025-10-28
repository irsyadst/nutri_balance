import 'package:flutter/material.dart';

class OnboardingPageContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool isLastPage;

  const OnboardingPageContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    const Radius defaultRadius = Radius.circular(50);
    final BorderRadius backgroundBorderRadius = const BorderRadius.only(
      bottomLeft: defaultRadius,
      bottomRight: defaultRadius,
    );

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF007BFF),
              borderRadius: backgroundBorderRadius,
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

        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white,
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