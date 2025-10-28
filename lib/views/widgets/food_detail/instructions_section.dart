import 'package:flutter/material.dart';

class InstructionsSection extends StatelessWidget {
  final List<String> steps;

  const InstructionsSection({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Langkah-Langkah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${steps.length} Langkah', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 15),
        // Gunakan ListView.builder jika langkahnya banyak
        ListView.builder(
          shrinkWrap: true, // Wajib di dalam SingleChildScrollView/CustomScrollView
          physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll internal
          itemCount: steps.length,
          itemBuilder: (context, index) {
            // Tentukan apakah langkah ini "aktif" (contoh: 5 langkah pertama)
            // bool isActive = index < 5; // Logika ini bisa disesuaikan
            bool isActive = true; // Atau anggap semua aktif
            return _buildTimelineStep(
              context: context,
              stepNumber: index + 1,
              description: steps[index],
              isActive: isActive,
              isLast: index == steps.length - 1, // Tandai jika ini langkah terakhir
            );
          },
        ),
      ],
    );
  }

  // Widget internal untuk satu langkah dalam timeline
  Widget _buildTimelineStep({
    required BuildContext context,
    required int stepNumber,
    required String description,
    required bool isActive,
    required bool isLast,
  }) {
    final activeColor = Theme.of(context).primaryColor; // Gunakan warna tema
    final color = isActive ? activeColor : Colors.grey.shade400;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0), // Kurangi jarak bawah sedikit
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Marker (Nomor dan Garis)
          Column(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                  color: Colors.white, // Latar belakang putih
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString().padLeft(2, '0'), // Format 01, 02, etc.
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ),
              // Tampilkan garis hanya jika bukan langkah terakhir
              if (!isLast)
                Container(
                  width: 2,
                  height: 65, // Tinggi garis penghubung (sesuaikan)
                  color: color,
                ),
            ],
          ),
          const SizedBox(width: 20),
          // Deskripsi Langkah
          Expanded(
            child: Padding( // Beri padding atas agar sejajar dengan lingkaran nomor
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Langkah $stepNumber', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.4)),
                  const SizedBox(height: 15), // Jarak antar deskripsi step
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}