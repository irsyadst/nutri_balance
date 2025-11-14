import 'package:flutter/material.dart';

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
          onTap: onTap,
          child: Text(
            linkText,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,

            ),
          ),
        ),
      ],
    );
  }
}