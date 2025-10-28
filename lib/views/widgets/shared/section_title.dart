import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key}); // Constructor positional singkat

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding bawah agar ada jarak ke konten di bawahnya
      padding: const EdgeInsets.only(bottom: 15.0, top: 10.0), // Tambah padding atas sedikit
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18, // Ukuran font sedikit lebih kecil
          fontWeight: FontWeight.bold,
          color: Colors.black87, // Warna sedikit lebih soft
        ),
      ),
    );
  }
}