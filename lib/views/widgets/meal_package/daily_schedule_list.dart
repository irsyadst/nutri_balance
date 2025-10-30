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

                // Gunakan data dari model MealPlan baru
                return ListTile(
                  leading: CircleAvatar(
                    // TODO: Ganti dengan icon berdasarkan meal.mealType
                    child: Icon(Icons.restaurant),
                  ),
                  title: Text(meal.food.name), // <-- Tampilkan nama makanan
                  subtitle: Text(meal.mealType), // <-- e.g., 'Sarapan'
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${meal.food.calories} kkal', // <-- Tampilkan kalori
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(meal.time), // <-- Tampilkan jam
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