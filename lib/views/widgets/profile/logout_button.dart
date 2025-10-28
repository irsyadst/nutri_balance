import 'package:flutter/material.dart';
import '../../../models/storage_service.dart'; // Import storage service
import '../../../views/screens/login_screen.dart'; // Import login screen

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  // Fungsi Logout dipindahkan ke sini
  void _logout(BuildContext context) async {
    // Tampilkan dialog konfirmasi
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(false); // Kirim false saat batal
              },
            ),
            TextButton(
              child: Text('Keluar', style: TextStyle(color: Colors.red.shade600)),
              onPressed: () {
                Navigator.of(context).pop(true); // Kirim true saat konfirmasi
              },
            ),
          ],
        );
      },
    );

    // Lanjutkan logout hanya jika user mengonfirmasi
    if (confirmLogout == true) {
      final storage = StorageService();
      await storage.deleteToken(); // Hapus token
      // Gunakan context.mounted untuk cek sebelum navigasi
      if (context.mounted) {
        // Navigasi ke LoginScreen dan hapus semua halaman sebelumnya
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false, // Hapus semua route
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding horizontal agar tombol tidak mepet
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon( // Gunakan ElevatedButton.icon
          icon: Icon(Icons.logout, color: Colors.red.shade100, size: 20), // Ikon logout
          label: const Text(
            'Keluar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Font size lebih kecil
          ),
          onPressed: () => _logout(context), // Panggil fungsi _logout
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50, // Warna background merah muda
            foregroundColor: Colors.red.shade700, // Warna teks/ikon merah tua
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Radius lebih besar
            elevation: 0, // Tanpa shadow
          ),
        ),
      ),
    );
  }
}