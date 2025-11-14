import 'package:flutter/material.dart';

class OtpHeader extends StatelessWidget {
  final String email;

  const OtpHeader({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "Verifikasi Kode OTP",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Text(
          "Masukkan 6 digit kode OTP yang telah dikirimkan ke email Anda ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
        ),
        Text(
          email,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.w500, height: 1.4),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}