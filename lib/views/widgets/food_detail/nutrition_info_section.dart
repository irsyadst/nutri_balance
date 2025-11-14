import 'package:flutter/material.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'nutrition_row.dart'; // Impor widget baris

class NutritionInfoSection extends StatelessWidget {
  final Food food;
  const NutritionInfoSection({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Nutrisi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '(per ${food.servingQuantity.toStringAsFixed(0)} ${food.servingUnit})',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Kalori
          NutritionRow(
            title: 'Kalori',
            value: '${food.calories.toStringAsFixed(0)} kkal',
            color: Theme.of(context).primaryColor,
            isHeader: true,
          ),
          const SizedBox(height: 20),

          // Makro
          NutritionRow(
              title: 'Protein',
              value: '${food.proteins.toStringAsFixed(1)} g',
              color: Colors.red.shade400),
          NutritionRow(
              title: 'Karbohidrat',
              value: '${food.carbs.toStringAsFixed(1)} g',
              color: Colors.green.shade400),
          NutritionRow(
              title: 'Lemak',
              value: '${food.fats.toStringAsFixed(1)} g',
              color: Colors.amber.shade600),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
