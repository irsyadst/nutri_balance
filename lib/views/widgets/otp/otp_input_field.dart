import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final Function(String)? onCompleted;
  final PinTheme? defaultPinTheme;
  final PinTheme? focusedPinTheme;
  final PinTheme? errorPinTheme; // Opsional: tema untuk error

  const OtpInputField({
    super.key,
    required this.controller,
    this.length = 6, // Default panjang OTP 6
    this.onCompleted,
    this.defaultPinTheme,
    this.focusedPinTheme,
    this.errorPinTheme,
  });

  @override
  Widget build(BuildContext context) {
    // Tema default jika tidak disediakan dari luar
    final defaultTheme = defaultPinTheme ?? PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Warna background field
        borderRadius: BorderRadius.circular(12), // Radius lebih besar
        border: Border.all(color: Colors.transparent), // Tanpa border default
      ),
    );

    // Tema saat field aktif (fokus)
    final focusedTheme = focusedPinTheme ?? defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: Theme.of(context).primaryColor, width: 1.5), // Border biru
        color: Colors.white, // Background putih saat fokus
      ),
    );

    // Tema saat terjadi error (opsional)
    final errorTheme = errorPinTheme ?? defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: Colors.redAccent, width: 1.5), // Border merah
      ),
    );


    return Pinput(
      length: length,
      controller: controller,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: focusedTheme,
      errorPinTheme: errorTheme, // Terapkan tema error
      onCompleted: onCompleted,
      autofocus: true, // Fokus otomatis saat layar tampil
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit, // Validasi saat selesai
      showCursor: true, // Tampilkan kursor
    );
  }
}