import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/storage_service.dart';
import 'login_screen.dart'; // Diperlukan untuk navigasi saat logout

class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  /// Fungsi untuk menangani proses logout.
  /// Ini akan menghapus token dari penyimpanan dan mengarahkan pengguna
  /// kembali ke halaman login.
  void _logout(BuildContext context) async {
    final storage = StorageService();
    await storage.deleteToken(); // Hapus token dari SharedPreferences

    // Navigasi ke halaman login dan hapus semua rute sebelumnya dari tumpukan
    // agar pengguna tidak bisa kembali ke halaman profil setelah logout.
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengakses data profil dengan aman, memberikan nilai default jika tidak ada
    final profile = user.profile;
    final height = profile?.height.toInt().toString() ?? 'N/A';
    final weight = profile?.currentWeight.toInt().toString() ?? 'N/A';
    final age = profile?.age.toString() ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        // Tombol aksi untuk logout di AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.redAccent),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Bagian Header Informasi Pengguna ---
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFE7F3FF),
                  child: Icon(Icons.person_outline, size: 40, color: Color(0xFF007BFF)),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$height cm | $weight kg | $age tahun',
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 35,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigasi ke halaman edit profil (belum dibuat)
                    },
                    child: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF007BFF),
                      side: const BorderSide(color: Color(0xFF007BFF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(),

            // --- Daftar Opsi Pengaturan Akun ---
            ListTile(
              leading: Icon(Icons.account_circle_outlined, color: Colors.grey[600]),
              title: const Text('Detail Akun'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Aksi untuk membuka halaman detail akun
              },
            ),
            ListTile(
              leading: Icon(Icons.shield_outlined, color: Colors.grey[600]),
              title: const Text('Keamanan'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Aksi untuk membuka halaman pengaturan keamanan
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_outlined, color: Colors.grey[600]),
              title: const Text('Notifikasi'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Aksi untuk membuka halaman pengaturan notifikasi
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined, color: Colors.grey[600]),
              title: const Text('Kebijakan Privasi'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Aksi untuk membuka halaman kebijakan privasi
              },
            ),
          ],
        ),
      ),
    );
  }
}