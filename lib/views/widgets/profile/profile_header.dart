// lib/views/widgets/profile/profile_header.dart

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
    // --- PERBAIKAN: Bungkus dengan Padding ---
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 15, 24, 10), // Padding seperti HomeHeader
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end, // Sejajarkan ke bawah
        children: [
          // Avatar dan Nama Pengguna
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome & Nama
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.name.isNotEmpty ? user.name : "Pengguna",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
          // Tombol Edit
          ElevatedButton(
            onPressed: onEditPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              elevation: 1,
            ),
            child: const Text('Edit',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    // --- AKHIR PERBAIKAN ---
  }
}