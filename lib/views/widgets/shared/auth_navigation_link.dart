import 'package:flutter/material.dart';

// Text link for navigating between Auth screens (Login <-> Signup)
class AuthNavigationLink extends StatelessWidget {
  final String leadingText;
  final String linkText;
  final VoidCallback onTap;

  const AuthNavigationLink({
    super.key,
    required this.leadingText,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(leadingText, style: const TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap: onTap, // Use the provided callback
          child: Text(
            linkText,
            style: TextStyle(
              // Use primary color from theme
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              // Optional: Add underline
              // decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}