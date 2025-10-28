import 'package:flutter/material.dart';
import '../../../models/user_model.dart'; // Import User model

class ProfileHeader extends StatelessWidget {
  final User user;
  final VoidCallback onEditPressed; // Callback untuk tombol Edit

  const ProfileHeader({
    super.key,
    required this.user,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar dan Nama Pengguna
        Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Sejajarkan vertikal
          children: [
            CircleAvatar(
              radius: 30, // Ukuran avatar
              backgroundColor: Colors.grey[200], // Warna placeholder
              // TODO: Ganti dengan path gambar avatar asli jika ada
              backgroundImage: const AssetImage('assets/images/avatar_placeholder.png'),
              // Fallback jika gambar gagal dimuat
              onBackgroundImageError: (_, __) {}, // Handle error (opsional)
              child: const ClipOval(child: null), // Pastikan bentuknya bulat
            ),
            const SizedBox(width: 15),
            // Welcome & Nama
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome,', // Sesuaikan sapaan jika perlu
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600), // Ukuran font lebih kecil
                ),
                const SizedBox(height: 2), // Jarak kecil
                Text(
                  user.name.isNotEmpty ? user.name : "Pengguna", // Tampilkan nama atau default
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87), // Ukuran font nama
                  overflow: TextOverflow.ellipsis, // Hindari overflow nama panjang
                ),
              ],
            ),
          ],
        ),
        // Tombol Edit
        ElevatedButton(
          onPressed: onEditPressed, // Gunakan callback
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor, // Warna primer
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10), // Sesuaikan padding
            elevation: 1, // Sedikit shadow
          ),
          child: const Text('Edit', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), // Ukuran font tombol
        ),
      ],
    );
  }
}