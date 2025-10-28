import 'package:flutter/material.dart';

class RecalculationWarningCard extends StatelessWidget {
  const RecalculationWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perubahan akan menghitung ulang kebutuhan kalori harian Anda!',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900),
                ),
                const SizedBox(height: 5),
                Text(
                  'Pastikan semua informasi sudah benar sebelum menyimpan.',
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}