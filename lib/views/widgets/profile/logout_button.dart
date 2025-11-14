// lib/views/widgets/profile/logout_button.dart
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {

  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.onPressed,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(Icons.logout, color: Colors.red.shade100, size: 20),
          label: const Text(
            'Keluar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red.shade700,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}