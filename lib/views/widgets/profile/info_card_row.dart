import 'package:flutter/material.dart';

// Widget untuk baris kartu info (Tinggi, Berat, Usia)
class InfoCardRow extends StatelessWidget {
  final int height;
  final int weight;
  final int age;

  const InfoCardRow({
    super.key,
    required this.height,
    required this.weight,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween, // Defaultnya spaceBetween
      children: [
        // Gunakan Expanded agar kartu mengisi ruang yang tersedia
        Expanded(child: _InfoCard(value: '$height cm', label: 'Tinggi')),
        const SizedBox(width: 12), // Jarak antar kartu
        Expanded(child: _InfoCard(value: '$weight kg', label: 'Berat')),
        const SizedBox(width: 12),
        Expanded(child: _InfoCard(value: '$age thn', label: 'Usia')), // Ubah label 'yo' ke 'thn'
      ],
    );
  }
}


// Widget internal untuk satu kartu info
class _InfoCard extends StatelessWidget {
  final String value;
  final String label;

  const _InfoCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10), // Sesuaikan padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // Border tipis
        border: Border.all(color: Colors.grey.shade200, width: 0.8),
        boxShadow: [
          // Shadow halus
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 17, // Sedikit lebih kecil
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor, // Warna primer
            ),
            textAlign: TextAlign.center, // Center text
          ),
          const SizedBox(height: 6), // Jarak antara value dan label
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]), // Ukuran label lebih kecil
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}