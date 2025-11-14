import 'package:flutter/material.dart';
import 'package:nutri_balance/controllers/home_controller.dart';

class MealTargetGrid extends StatelessWidget {
  final Map<String, Map<String, dynamic>> targets;
  final Map<String, double> consumedData;
  final HomeController controller;

  const MealTargetGrid({
    super.key,
    required this.targets,
    required this.consumedData,
    required this.controller,
  });

  // Map untuk ikon
  static const Map<String, IconData> mealIcons = {
    'Sarapan': Icons.wb_sunny_outlined,
    'Makan Siang': Icons.restaurant_menu_outlined,
    'Makan Malam': Icons.nights_stay_outlined,
    'Makanan Ringan': Icons.bakery_dining_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final mealTitles = ['Sarapan', 'Makan Siang', 'Makan Malam', 'Makanan Ringan'];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mealTitles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final title = mealTitles[index];

        final targetMap = targets[title]; // Ini adalah Map<String, dynamic>?
        final target = (targetMap?['target'] as num?)?.toDouble() ?? 0.0;
        final unit = (targetMap?['unit'] as String?) ?? 'kkal';
        // --- Akhir Fix 1 ---

        final consumed = consumedData[title] ?? 0.0;
        final icon = mealIcons[title] ?? Icons.help_outline;

        return _buildMealTargetCard(
          context: context,
          title: title,
          icon: icon,
          consumed: consumed,
          target: target,
          unit: unit,
        );
      },
    );
  }

  Widget _buildMealTargetCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required double consumed,
    required double target,
    required String unit,
  }) {

    final double progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    final bool isOverTarget = consumed > target && target > 0;
    final Color progressColor = isOverTarget ? Colors.red.shade600 : const Color(0xFF007BFF);
    final Color textColor = isOverTarget ? Colors.red.shade600 : Colors.black54;
    final FontWeight textWeight = isOverTarget ? FontWeight.bold : FontWeight.normal;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${consumed.round()} / ${target.round()} $unit',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontWeight: textWeight,
                ),
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