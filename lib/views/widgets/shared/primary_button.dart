import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Sekarang bisa null
  final bool small;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed, // Tidak lagi required
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: small ? null : double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: small ? 12 : 18, horizontal: small ? 20 : 0),
          // Mengambil warna dari primaryColor di ThemeData
          backgroundColor: Theme.of(context).primaryColor,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Lebih kotak sesuai desain
          elevation: 0, // Tidak ada shadow
        ),
        child: Text(
          text,
          style: TextStyle(
            color: onPressed == null ? Colors.grey.shade600 : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold, // Tambah bold sesuai desain
          ),
        ),
      ),
    );
  }
}