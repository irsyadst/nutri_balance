// lib/views/widgets/home/meal_target_grid.dart
import 'package:flutter/material.dart';
import 'dart:math';

class MealTargetGrid extends StatelessWidget {
  // Terima data target dari luar (misal dari profil user)
  final Map<String, Map<String, dynamic>> targets;
  // Terima data konsumsi hari ini dari luar
  final Map<String, double> consumedData; // Contoh: {'Sarapan': 500.0, 'Air': 2.0}

  const MealTargetGrid({
    super.key,
    required this.targets, // Jadikan wajib
    required this.consumedData, // Jadikan wajib
  });

  @override
  Widget build(BuildContext context) {
    final keys = targets.keys.toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final title = keys[index];
        final targetData = targets[title]!;
        // Ambil data konsumsi untuk title ini, default 0 jika tidak ada
        final currentConsumed = consumedData[title] ?? 0.0;

        return _MealTargetCard(
          title: title,
          icon: targetData['icon'] as IconData,
          // Gunakan data konsumsi dari parameter
          consumed: currentConsumed,
          target: (targetData['target'] as num?)?.toDouble() ?? 0.0, // Konversi target ke double
          unit: targetData['unit'] as String,
        );
      },
    );
  }
}

// _MealTargetCard (internal widget) tetap sama
class _MealTargetCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double consumed;
  final double target;
  final String unit;

  const _MealTargetCard({
    required this.title,
    required this.icon,
    required this.consumed,
    required this.target,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (target > 0) ? min(1.0, consumed / target) : 0.0;
    final progressColor = (unit == 'L' || (unit == 'kkal' && title != 'Aktivitas'))
        ? const Color(0xFF007BFF) // Blue
        : Colors.green.shade400; // Green for activity

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space vertically
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                unit == 'L'
                    ? '${consumed.toStringAsFixed(1)} / ${target.toStringAsFixed(1)} $unit'
                    : '${consumed.round()} / ${target.round()} $unit',
                style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
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
    );
  }
}