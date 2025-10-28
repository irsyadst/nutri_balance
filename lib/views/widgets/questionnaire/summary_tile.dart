import 'package:flutter/material.dart';

// Widget untuk menampilkan satu baris informasi di halaman ringkasan
class SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final bool hasDivider;

  const SummaryTile({
    super.key,
    required this.label,
    required this.value,
    this.hasDivider = true, // Defaultnya ada divider
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding horizontal
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding vertikal
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Label kiri, value kanan
              crossAxisAlignment: CrossAxisAlignment.start, // Align text ke atas jika value panjang
              children: [
                // Label
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(width: 10), // Jarak antara label dan value
                // Value (Fleksibel agar tidak overflow)
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right, // Rata kanan
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, // Font weight sedikit tebal
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          // Tampilkan divider jika hasDivider true
          if (hasDivider) Divider(height: 1, thickness: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }
}