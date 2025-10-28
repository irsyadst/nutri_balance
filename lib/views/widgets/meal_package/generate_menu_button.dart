import 'package:flutter/material.dart';
import '../../screens/generate_menu_screen.dart'; // Untuk navigasi

class GenerateMenuButton extends StatelessWidget {
  const GenerateMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Beri padding horizontal agar tidak mepet layar
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ElevatedButton(
        onPressed: () {
          // Navigasi ke GenerateMenuScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GenerateMenuScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor, // Warna primer
          foregroundColor: Colors.white, // Warna teks
          minimumSize: const Size(double.infinity, 55), // Lebar penuh, tinggi 55
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2, // Sedikit shadow
        ),
        child: const Text(
          'Hasilkan Menu Otomatis',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Teks Bold
        ),
      ),
    );
  }
}