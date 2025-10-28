import 'package:flutter/material.dart';

class NutritionInfoChips extends StatelessWidget {
  final int calories;
  final int protein;
  final int fat;
  final int carbs;

  const NutritionInfoChips({
    super.key,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            '$calories kkal',
            const Color(0xFFEF5350).withOpacity(0.1), // Merah muda
            const Color(0xFFEF5350), // Merah
            Icons.local_fire_department_outlined, // Ganti ikon jika perlu
          ),
          _buildChip(
            '${protein}g protein',
            const Color(0xFF007BFF).withOpacity(0.1), // Biru muda
            const Color(0xFF007BFF), // Biru
            Icons.fitness_center_outlined, // Ganti ikon jika perlu
          ),
          _buildChip(
            '${fat}g lemak',
            const Color(0xFFFFC107).withOpacity(0.1), // Kuning muda
            const Color(0xFFFFC107), // Kuning
            Icons.opacity_outlined, // Ganti ikon jika perlu (contoh: tetesan minyak)
          ),
          _buildChip(
            '${carbs}g karbo',
            const Color(0xFF4CAF50).withOpacity(0.1), // Hijau muda
            const Color(0xFF4CAF50), // Hijau
            Icons.grain_outlined, // Ganti ikon jika perlu
          ),
        ],
      ),
    );
  }

  // Helper widget untuk membuat chip individual (bisa tetap di sini)
  Widget _buildChip(String label, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}