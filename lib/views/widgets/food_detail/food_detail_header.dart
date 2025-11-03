import 'package:flutter/material.dart';
import 'package:nutri_balance/models/meal_models.dart';

class FoodDetailHeader extends StatelessWidget {
  final Food food;
  const FoodDetailHeader({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black12,
            child: Icon(Icons.restaurant_menu, color: Colors.black54, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Takaran Saji: ${food.servingQuantity.toStringAsFixed(0)} ${food.servingUnit}',
                  style:
                  const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
