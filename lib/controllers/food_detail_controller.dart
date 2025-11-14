import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'package:nutri_balance/controllers/add_food_controller.dart';
import 'package:nutri_balance/views/widgets/add_food/log_food_modal.dart';


class FoodDetailController {
  final Food food;

  final AddFoodController? addFoodController;
  final double initialQuantity;
  final String initialMealType;

  FoodDetailController({
    required this.food,
    this.addFoodController,
    required this.initialQuantity,
    required this.initialMealType,
  });

  String _getMealTypeFromTime() {
    if (initialQuantity != 1.0) {
      return initialMealType;
    }

    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 10) return 'Sarapan';
    if (hour >= 10 && hour < 14) return 'Makan Siang';
    if (hour >= 14 && hour < 18) return 'Snack';
    if (hour >= 18 && hour < 22) return 'Makan Malam';
    return 'Snack'; // Default
  }

  void showLogFoodModal(BuildContext context) {
    if (addFoodController == null) {
      debugPrint("showLogFoodModal dipanggil tanpa AddFoodController. Ini seharusnya tidak terjadi.");
      return;
    }

    String mealType = _getMealTypeFromTime();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return LogFoodModal(
          food: food,
          initialQuantity: initialQuantity,
          initialMealType: mealType,
          onLog: (quantity, mealType) async {
            final success = await addFoodController!.logFood(
              foodId: food.id,
              quantity: quantity,
              mealType: mealType,
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            );

            if (context.mounted) {
              Navigator.of(ctx).pop(); // Tutup modal
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${food.name} berhasil dicatat!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${addFoodController!.errorMessage}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}