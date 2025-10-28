import 'package:flutter/material.dart';
import 'dart:math'; // For min function

class MealTargetGrid extends StatelessWidget {
  // Example data structure (consider passing this from the screen or a controller)
  final Map<String, Map<String, dynamic>> targets = const {
    'Sarapan': {'icon': Icons.wb_sunny_outlined, 'consumed': 500.0, 'target': 600.0, 'unit': 'kkal'},
    'Makan siang': {'icon': Icons.restaurant_menu_outlined, 'consumed': 400.0, 'target': 700.0, 'unit': 'kkal'},
    'Makan malam': {'icon': Icons.nights_stay_outlined, 'consumed': 0.0, 'target': 600.0, 'unit': 'kkal'},
    'Makanan ringan': {'icon': Icons.bakery_dining_outlined, 'consumed': 400.0, 'target': 313.0, 'unit': 'kkal'},
    'Air': {'icon': Icons.water_drop_outlined, 'consumed': 2.0, 'target': 3.0, 'unit': 'L'},
    'Aktivitas': {'icon': Icons.fitness_center_outlined, 'consumed': 600.0, 'target': 900.0, 'unit': 'kkal'},
  };

  const MealTargetGrid({super.key});

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
        childAspectRatio: 1.8, // Adjust ratio for desired card height
      ),
      itemBuilder: (context, index) {
        final title = keys[index];
        final data = targets[title]!;
        // Pass data to the individual card widget
        return _MealTargetCard(
          title: title,
          icon: data['icon'] as IconData,
          consumed: data['consumed'] as double,
          target: data['target'] as double,
          unit: data['unit'] as String,
        );
      },
    );
  }
}

// --- Internal Widget for Individual Target Card ---
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
    // Calculate progress safely
    final double progress = (target > 0) ? min(1.0, consumed / target) : 0.0;
    // Determine progress bar color (e.g., blue for food/water, green for activity)
    final progressColor = (unit == 'L' || unit == 'kkal' && title != 'Aktivitas')
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
          // Icon and Title Row
          Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Expanded( // Prevent title overflow
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Consumed/Target Text and Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // Format text: 1 decimal for Liters, round for kkal
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