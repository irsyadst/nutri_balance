import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutri_balance/controllers/meal_package_controller.dart';
// --- IMPOR BARU ---
import 'package:nutri_balance/views/screens/food_detail_screen.dart';
// --- AKHIR IMPOR BARU ---

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

                // Kalkulasi kalori total masih benar
                // (Kalori dasar * pengali)
                final totalCalories = meal.food.calories * meal.quantity;

                // misal: "150 g" atau "1 butir"
                String quantityText =
                    "${meal.displayQuantity.toStringAsFixed(0)} ${meal.displayUnit}";

                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.restaurant),
                  ),
                  // Tampilkan nama makanan
                  title: Text(meal.food.name),
                  // Tampilkan Tipe Makanan • Kuantitas (misal: "Makan Siang • 150 g")
                  subtitle: Text("${meal.mealType} • $quantityText"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        // Tampilkan kalori yang sudah dikalikan
                        '${totalCalories.toStringAsFixed(0)} kkal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(meal.time),
                    ],
                  ),
                  // --- TAMBAHAN ONTAP ---
                  onTap: () {
                    // Navigasi ke FoodDetailScreen
                    // Kita passing 'null' untuk controller karena ini mode "view-only"
                    Get.to(() => FoodDetailScreen(
                      food: meal.food,
                      controller: null, // <-- Perubahan di sini
                      initialQuantity: meal.quantity,
                      initialMealType: meal.mealType,
                    ));
                  },
                  // --- AKHIR TAMBAHAN ---
                );
              },
            );
          }),
        ),
      ],
    );
  }
}