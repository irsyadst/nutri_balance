import 'package:flutter/material.dart';

// Container umum untuk setiap bagian (Akun, Notifikasi, Lainnya)
class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children; // Daftar widget di dalam section (ListTile, SwitchListTile)

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding atas/bawah antar section
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Section
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 12.0), // Padding judul
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), // Font size lebih kecil
            ),
          ),
          // Container pembungkus item-item
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.08), // Shadow halus
                    blurRadius: 15,
                    offset: const Offset(0, 3)
                )
              ],
              // Optional: tambahkan border
              // border: Border.all(color: Colors.grey.shade200, width: 0.8),
            ),
            // ClipRRect agar item di dalamnya mengikuti border radius container
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(children: children), // Tampilkan children (ListTile, Divider, etc.)
            ),
          ),
        ],
      ),
    );
  }
}