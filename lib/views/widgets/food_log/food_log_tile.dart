import 'package:flutter/material.dart';
import 'package:nutri_balance/models/food_log_model.dart';

class FoodLogTile extends StatelessWidget {
  final FoodLogEntry log;
  const FoodLogTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    // Hitung total kalori untuk entri ini
    final totalCalories = (log.food.calories * log.quantity).toStringAsFixed(0);

    // Tampilkan kuantitas dan unit
    final quantityText =
        '${log.displayQuantity.toStringAsFixed(log.displayUnit == 'g' ? 0 : 1)} ${log.displayUnit}';

    return ListTile(
      title: Text(log.food.name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(quantityText, style: const TextStyle(color: Colors.black54)),
      trailing: Text(
        '$totalCalories kkal',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      onTap: () {
        // TODO: Navigasi ke detail log? Atau biarkan?
        print('Tapped on ${log.food.name}');
      },
    );
  }
}
