import 'package:flutter/material.dart';
import 'dart:math';
import '../../../controllers/home_controller.dart';

class MealTargetGrid extends StatelessWidget {
// ... (Kode build() dan _buildCard() tetap sama) ...
  final Map<String, Map<String, dynamic>> targets;
  final Map<String, double> consumedData;
  final HomeController controller;

  const MealTargetGrid({
    super.key,
    required this.targets,
    required this.consumedData,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Kita tidak lagi menggunakan GridView.builder
    // Kita susun manual menggunakan Column dan Row
    return Column(
      children: [
        // Baris 1: Sarapan & Makan Siang
        Row(
          children: [
            Expanded(
              child: _buildCard('Sarapan'),
            ),
            const SizedBox(width: 15), // Jarak antar card
            Expanded(
              child: _buildCard('Makan Siang'),
            ),
          ],
        ),
        const SizedBox(height: 15), // Jarak antar baris

        // Baris 2: Makan Malam & Snack
        Row(
          children: [
            Expanded(
              child: _buildCard('Makan Malam'),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildCard('Snack'),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Baris 3: Air (Full Width)
        _buildCard('Air'),
      ],
    );
  }

  // Helper untuk membangun data card
  Widget _buildCard(String title) {
    final targetData = targets[title];
    if (targetData == null) return const SizedBox.shrink();

    final currentConsumed = consumedData[title] ?? 0.0;
    final bool isWater = (title == 'Air');

    return _MealTargetCard(
      title: title,
      icon: targetData['icon'] as IconData? ?? Icons.error_outline,
      consumed: currentConsumed,
      target: (targetData['target'] as num?)?.toDouble() ?? 0.0,
      unit: targetData['unit'] as String? ?? '',
      isWaterCard: isWater,
      onAddWater: isWater ? () => controller.addWater(0.25) : null,
      onRemoveWater: isWater ? () => controller.removeWater(0.25) : null,
    );
  }
}

// _MealTargetCard (internal widget)
// Widget ini sekarang memiliki DUA layout: satu untuk meal, satu untuk air.
class _MealTargetCard extends StatelessWidget {
// ... (Properti tetap sama) ...
  final String title;
  final IconData icon;
  final double consumed;
  final double target;
  final String unit;
  final bool isWaterCard;
  final VoidCallback? onAddWater;
  final VoidCallback? onRemoveWater;

  const _MealTargetCard({
    required this.title,
    required this.icon,
    required this.consumed,
    required this.target,
    required this.unit,
    this.isWaterCard = false,
    this.onAddWater,
    this.onRemoveWater,
  });


  @override
  Widget build(BuildContext context) {
    // Pilih layout berdasarkan apakah ini card Air atau bukan
    if (isWaterCard) {
      return _buildWaterLayout(context);
    } else {
      return _buildMealLayout(context);
    }
  }

  // --- LAYOUT BARU UNTUK AIR (DENGAN PROGRESS BAR) ---
  Widget _buildWaterLayout(BuildContext context) {
    final progressColor = Colors.lightBlue.shade400;
    // --- TAMBAHAN: Hitung progres air ---
    final double progress = (target > 0) ? min(1.0, consumed / target) : 0.0;

    return Container(
      // Padding di dalam card
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // --- TAMBAHAN: Bungkus dengan Column ---
      child: Column(
        children: [
          Row(
            children: [
              // Icon dan Judul
              Icon(icon, color: Colors.grey.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              const Spacer(), // Mendorong tombol ke kanan

              // Tombol-tombol Aksi
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol (-)
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: const Icon(Icons.remove),
                      onPressed: onRemoveWater,
                      style: IconButton.styleFrom(
                        backgroundColor: progressColor.withOpacity(0.2),
                        foregroundColor: progressColor,
                      ),
                    ),
                  ),
                  // Teks Kuantitas
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${consumed.toStringAsFixed(1)} / ${target.toStringAsFixed(1)} L',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  // Tombol (+)
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton.filled(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: const Icon(Icons.add),
                      onPressed: onAddWater,
                      style: IconButton.styleFrom(
                        backgroundColor: progressColor.withOpacity(0.2),
                        foregroundColor: progressColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // --- TAMBAHAN: Progress Bar ---
          const SizedBox(height: 12), // Jarak dari row ke progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6, // Sesuaikan tinggi bar
            ),
          ),
          // --- AKHIR TAMBAHAN ---
        ],
      ),
    );
  }

  // --- LAYOUT LAMA UNTUK MEAL (KOTAK & VERTIKAL) ---
  Widget _buildMealLayout(BuildContext context) {
    final double progress = (target > 0) ? min(1.0, consumed / target) : 0.0;
    final progressColor = const Color(0xFF007BFF); // Warna biru

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1.7, // Rasio yang sama dengan yang kita hapus
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Baris Atas (Ikon, Judul)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),

            // Bagian Bawah (Teks Progress & Bar)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${consumed.round()} / ${target.round()} $unit',
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

