import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'package:nutri_balance/controllers/add_food_controller.dart';
import 'package:nutri_balance/views/widgets/add_food/log_food_modal.dart';

/// Controller ini tidak menggunakan ChangeNotifier karena
/// state utamanya (seperti isLoading) dikelola oleh AddFoodController.
/// Ini bertindak sebagai pengelola logika khusus untuk FoodDetailScreen.
class FoodDetailController {
  final Food food;
  final AddFoodController addFoodController;
  final double initialQuantity;
  final String initialMealType;

  FoodDetailController({
    required this.food,
    required this.addFoodController,
    required this.initialQuantity,
    required this.initialMealType,
  });

  // Fungsi untuk menentukan meal type default berdasarkan waktu
  String _getMealTypeFromTime() {
    // Jika initialQuantity BUKAN default (artinya dari rekomendasi),
    // gunakan initialMealType dari rekomendasi tersebut.
    if (initialQuantity != 1.0) {
      return initialMealType;
    }

    // Jika tidak, tentukan berdasarkan waktu saat ini
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 10) return 'Sarapan';
    if (hour >= 10 && hour < 14) return 'Makan Siang';
    if (hour >= 14 && hour < 18) return 'Snack';
    if (hour >= 18 && hour < 22) return 'Makan Malam';
    return 'Snack'; // Default
  }

  // Fungsi untuk menampilkan modal log
  void showLogFoodModal(BuildContext context) {
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
            // Panggil AddFoodController untuk benar-benar mencatat data
            final success = await addFoodController.logFood(
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
                // Pop dua kali: 1. tutup modal (di atas), 2. tutup detail screen
                Navigator.of(context).pop(true); // Kirim 'true' untuk refresh
              } else {
                // Tampilkan error dari addFoodController
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${addFoodController.errorMessage}'),
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
