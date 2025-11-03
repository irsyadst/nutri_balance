import 'package:flutter/material.dart';

class ViewLogButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ViewLogButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: const Icon(Icons.history, size: 20),
        label: const Text(
          'Lihat Catatan Harian',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
          ),
        ),
        onPressed: onPressed,
        style: TextButton.styleFrom(
          // Mengambil warna dari tema utama
          foregroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
