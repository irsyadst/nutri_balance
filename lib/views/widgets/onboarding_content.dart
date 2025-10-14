import 'package:flutter/material.dart';

class OnboardingPageContent extends StatelessWidget {
  final String title, description;
  const OnboardingPageContent({super.key, required this.title, required this.description});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.track_changes, size: MediaQuery.of(context).size.height * 0.3, color: const Color(0xFF82B0F2)),
        const SizedBox(height: 50),
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D1617))),
        const SizedBox(height: 15),
        Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ]),
    );
  }
}
