import 'package:flutter/material.dart';

// Widget untuk menampilkan kartu rincian makronutrien di tab ringkasan
class MacroBreakdownCard extends StatelessWidget {
  final String macroRatio; // Contoh: "40/30/30"
  final double macroChangePercent;
  final Map<String, double> macroDataPercentage; // Data persentase per makro

  const MacroBreakdownCard({
    super.key,
    required this.macroRatio,
    required this.macroChangePercent,
    required this.macroDataPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final percentColor = macroChangePercent >= 0 ? Colors.green.shade500 : Colors.red.shade400;
    final percentText = '${macroChangePercent >= 0 ? '+' : ''}${macroChangePercent.toStringAsFixed(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info Rasio Makro
        const Text('Makro', style: TextStyle(fontSize: 15, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(macroRatio, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          'Hari ini $percentText',
          style: TextStyle( fontSize: 14, color: percentColor, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),

        // Daftar Progress Bar Makro
        ...macroDataPercentage.entries.map((entry) {
          return _MacroBar( // Gunakan widget internal _MacroBar
            label: entry.key,
            percentage: entry.value,
            // Tentukan warna berdasarkan label
            color: _getColorForMacro(entry.key, context),
          );
        }).toList(),
      ],
    );
  }

  // Helper untuk menentukan warna bar makro
  Color _getColorForMacro(String label, BuildContext context) {
    switch (label.toLowerCase()) {
      case 'protein':
        return Theme.of(context).primaryColor; // Biru (warna primer)
      case 'karbohidrat':
      case 'carbs': // Handle variasi nama
        return Colors.green.shade400; // Hijau
      case 'lemak':
      case 'fats': // Handle variasi nama
        return Colors.amber.shade400; // Kuning/Oranye
      default:
        return Colors.grey; // Warna default
    }
  }
}


// Widget internal untuk satu progress bar makro
class _MacroBar extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;

  const _MacroBar({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Jarak antar bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Makro (Protein, dll.)
          Text(
            // Tampilkan persentase di samping label
              '$label (${percentage.toStringAsFixed(0)}%)',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700)
          ),
          const SizedBox(height: 6), // Jarak label ke bar
          // Progress Bar Linear
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              // Pastikan nilai antara 0.0 dan 1.0
              value: (percentage / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200, // Warna background
              valueColor: AlwaysStoppedAnimation<Color>(color), // Warna progress
              minHeight: 10, // Tinggi bar (sedikit lebih tebal)
            ),
          ),
        ],
      ),
    );
  }
}