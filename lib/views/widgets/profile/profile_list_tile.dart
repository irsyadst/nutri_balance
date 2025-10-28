import 'package:flutter/material.dart';

// ListTile kustom untuk item-item di profile
class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showArrow; // Opsi untuk menampilkan/menyembunyikan panah

  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showArrow = true, // Defaultnya tampilkan panah
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600], size: 24), // Ukuran ikon konsisten
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      // Tampilkan panah hanya jika showArrow true
      trailing: showArrow
          ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400) // Ukuran panah lebih kecil
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Sesuaikan padding
      visualDensity: VisualDensity.compact, // Buat lebih rapat
    );
  }
}

// Widget Divider kustom (opsional, bisa juga pakai Divider biasa)
class ProfileListDivider extends StatelessWidget {
  const ProfileListDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding agar divider tidak mentok kiri-kanan
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        height: 1, // Tinggi divider (space vertikal)
        thickness: 0.8, // Ketebalan garis
        color: Colors.grey[100], // Warna abu-abu sangat muda
      ),
    );
  }
}