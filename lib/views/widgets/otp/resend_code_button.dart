import 'package:flutter/material.dart';

class ResendCodeButton extends StatelessWidget {
  final int countdown; // Waktu hitung mundur saat ini
  final VoidCallback onResend; // Callback saat tombol ditekan (ketika aktif)

  const ResendCodeButton({
    super.key,
    required this.countdown,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = countdown == 0; // Tombol aktif jika countdown 0
    String countdownText = countdown.toString().padLeft(2, '0'); // Format 00:XX

    return TextButton(
      // Nonaktifkan tombol jika countdown > 0
      onPressed: isActive ? onResend : null,
      child: Text(
        isActive
            ? "Kirim Ulang Kode"
            : "Kirim Ulang Kode (00:$countdownText)",
        style: TextStyle(
          // Warna berbeda saat aktif dan tidak aktif
          color: isActive ? Theme.of(context).primaryColor : Colors.grey,
          fontSize: 16,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, // Sedikit tebal saat aktif
        ),
      ),
    );
  }
}