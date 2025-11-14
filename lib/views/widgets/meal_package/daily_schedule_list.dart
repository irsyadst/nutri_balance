// lib/views/widgets/meal_package/daily_schedule_list.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutri_balance/controllers/meal_package_controller.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'package:nutri_balance/views/screens/food_detail_screen.dart';

class DailyScheduleList extends StatelessWidget {
  final MealPackageController controller = Get.find<MealPackageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      }

      final meals = controller.dailySchedule;

      if (meals.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month_outlined,
                    size: 60, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada menu',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coba generate menu untuk tanggal ini atau pilih tanggal lain.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
              ],
            ),
          ),
        );
      }

      final sarapanMeals =
      meals.where((m) => m.mealType == 'Sarapan').toList();
      final makanSiangMeals =
      meals.where((m) => m.mealType == 'Makan Siang').toList();
      final makanMalamMeals =
      meals.where((m) => m.mealType == 'Makan Malam').toList();
      final snackMeals = meals.where((m) => m.mealType == 'Snack').toList();

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMealSection(
              title: 'Sarapan',
              icon: Icons.breakfast_dining_outlined,
              meals: sarapanMeals,
            ),
            _buildMealSection(
              title: 'Makan Siang',
              icon: Icons.lunch_dining_outlined,
              meals: makanSiangMeals,
            ),
            _buildMealSection(
              title: 'Makan Malam',
              icon: Icons.dinner_dining_outlined,
              meals: makanMalamMeals,
            ),
            _buildMealSection(
              title: 'Snack',
              icon: Icons.fastfood_outlined,
              meals: snackMeals,
            ),
          ],
        ),
      );

    });
  }

  Widget _buildMealSection({
    required String title,
    required IconData icon,
    required List<MealPlan> meals,
  }) {
    if (meals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(icon, color: Colors.grey[700], size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Column(
            children: meals.map((meal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: _buildMealTile(meal),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTile(MealPlan meal) {
    final food = meal.food;

    return InkWell(
      onTap: () {
        Get.to(() => FoodDetailScreen(food: food));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200.withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.restaurant_menu, color: Colors.grey[400], size: 30),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(food.calories * meal.quantity).round()} kkal • ${meal.quantity.round()} porsi',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Icon panah
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}