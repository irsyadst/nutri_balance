// lib/views/widgets/profile/logout_button.dart
import 'package:flutter/material.dart';
// Import yang tidak perlu lagi dihapus
// import '../../../models/storage_service.dart';
// import '../../../views/screens/login_screen.dart';

class LogoutButton extends StatelessWidget {
  // Tambahkan callback onPressed
  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.onPressed, // Jadikan wajib
  });

  // --- FUNGSI LOGOUT DIPINDAHKAN KE CONTROLLER ---
  // void _logout(BuildContext context) async { ... } // DIHAPUS

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding horizontal agar tombol tidak mepet
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          // Gunakan ElevatedButton.icon
          icon: Icon(Icons.logout, color: Colors.red.shade100, size: 20),
          label: const Text(
            'Keluar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: onPressed, // Panggil callback dari parameter
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red.shade700,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}