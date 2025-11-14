// lib/views/widgets/add_food/recommendation_tab_view.dart

import 'package:flutter/material.dart';
import '../../../controllers/add_food_controller.dart';
import 'food_result_tile.dart';
import '../../screens/food_detail_screen.dart';

class RecommendationTabView extends StatelessWidget {
  final AddFoodController controller;

  const RecommendationTabView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.status == AddFoodStatus.loading &&
        controller.recommendedFoods.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.status == AddFoodStatus.error &&
        controller.recommendedFoods.isEmpty) {
      return Center(
          child: Text(controller.errorMessage,
              style: const TextStyle(color: Colors.red)));
    }

    if (controller.recommendedFoods.isEmpty) {
      return const Center(
          child: Text('Tidak ada rekomendasi hari ini.',
              style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: controller.recommendedFoods.length,
      itemBuilder: (context, index) {
        final meal = controller.recommendedFoods[index];
        final food = meal.food;
        final subtitle =
            '${meal.displayQuantity.toStringAsFixed(0)} ${meal.displayUnit} • ${meal.mealType}';

        return FoodResultTile(
          food: food,
          subtitle: subtitle,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodDetailScreen(
                  food: food,
                  controller: controller,
                  initialQuantity: meal.quantity,
                  initialMealType: meal.mealType,
                ),
              ),
            );
          },
        );
      },
    );
  }
}