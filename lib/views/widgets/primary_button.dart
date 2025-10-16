import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool small;
  const PrimaryButton({super.key, required this.text, required this.onPressed, this.small = false});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: small ? null : double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: small ? 12 : 18, horizontal: small ? 20 : 0),
          backgroundColor: const Color(0xFF82B0F2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}