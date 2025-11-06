// lib/views/widgets/statistics/water_detail_content.dart
import 'package:flutter/material.dart';
import 'package:nutri_balance/controllers/statistics_controller.dart';

class WaterDetailContent extends StatelessWidget {
  // Tambahkan ini
  final StatisticsController controller;

  const WaterDetailContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // TODO: Build UI untuk detail air
    // Anda bisa mengambil data dari controller.waterIntake (jika sudah ada)
    return Center(
      child: Column(
        children: [
          Icon(Icons.water_drop_outlined, size: 50, color: Colors.blue.shade200),
          const SizedBox(height: 16),
          const Text(
            'Detail Asupan Air',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fitur ini sedang dalam pengembangan.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}