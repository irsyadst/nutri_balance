import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutri_balance/controllers/meal_package_controller.dart';
// Hapus import model lama jika ada

class DailyScheduleList extends StatelessWidget {
  final MealPackageController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            'Jadwal Hari Ini',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          // Gunakan Obx untuk mendengarkan perubahan state
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              return Center(
                child: Text('Error: ${controller.errorMessage.value}'),
              );
            }

            if (controller.dailySchedule.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada rencana makan untuk hari ini.\nCoba generate menu.',
                  textAlign: TextAlign.center,
                ),
              );
            }

            // Jika data ada, tampilkan ListView
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.dailySchedule.length,
              itemBuilder: (context, index) {
                final meal = controller.dailySchedule[index];
                final totalCalories = meal.food.calories * meal.quantity;
                // Tampilkan quantity jika lebih dari 1
                String quantityText = (meal.quantity > 1)
                    ? ' (x${meal.quantity.toStringAsFixed(1)})'
                    : '';
                // Gunakan data dari model MealPlan baru
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.restaurant),
                  ),
                  // Tampilkan nama + quantity
                  title: Text(meal.food.name + quantityText), // <-- UBAH INI
                  subtitle: Text(meal.mealType),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        // Tampilkan kalori yang sudah dikalikan
                        '${totalCalories.toStringAsFixed(0)} kkal', // <-- UBAH INI
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(meal.time),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}