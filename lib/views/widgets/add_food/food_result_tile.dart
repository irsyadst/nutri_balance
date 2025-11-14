import 'package:flutter/material.dart';
import 'package:nutri_balance/models/meal_models.dart';

class FoodResultTile extends StatelessWidget {
  final Food food;
  final String? subtitle;
  final VoidCallback onTap;

  const FoodResultTile({
    super.key,
    required this.food,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.black12,
        child: Icon(Icons.restaurant_menu, color: Colors.black54),
      ),
      title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle ?? '${food.calories.toStringAsFixed(0)} kkal • ${food.servingQuantity.toStringAsFixed(0)} ${food.servingUnit}',
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: const Icon(Icons.add, color: Colors.blue),
      onTap: onTap,
    );
  }
}