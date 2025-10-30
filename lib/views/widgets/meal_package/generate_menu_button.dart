import 'package:flutter/material.dart';

class GenerateMenuButton extends StatelessWidget {
  // TAMBAHKAN DUA BARIS INI
  final VoidCallback onPressed;

  const GenerateMenuButton({
    Key? key,
    required this.onPressed, // TAMBAHKAN INI
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // GUNAKAN 'onPressed' DARI KONSTRUKTOR
        onPressed: onPressed,
        child: Text('Generate Menu Makanan'),
      ),
    );
  }
}