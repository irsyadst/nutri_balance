import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const SecondaryButton({super.key, required this.text, required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 22),
        label: Text(text, style: const TextStyle(color: Colors.black)),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            side: BorderSide(color: Colors.grey[300]!)
        ),
      ),
    );
  }
}
