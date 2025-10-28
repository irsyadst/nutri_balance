import 'package:flutter/material.dart';
// Remove unnecessary imports like dart:math, flutter_svg
import '../../models/user_model.dart';
// Import the new widgets
import '../widgets/home/home_header.dart';
import '../widgets/home/calorie_macro_card.dart';
import '../widgets/home/target_check_button.dart';
import '../widgets/home/meal_target_grid.dart';
import '../widgets/home/add_food_button.dart';
// Keep necessary screen imports if needed elsewhere, otherwise remove
// import 'activity_tracker_screen.dart';
// import 'notification_screen.dart';
// import 'add_food_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  // Remove static data, it should ideally come from a controller or be passed down
  // final double caloriesEaten = 1721;
  // ... (remove other static data) ...
  // final Map<String, Map<String, dynamic>> mealTargets = const { ... };
  // final Map<String, Map<String, dynamic>> otherTargets = const { ... };

  @override
  Widget build(BuildContext context) {
    // Data should ideally come from a state management solution (Provider, Riverpod, Bloc)
    // For now, let's use dummy data passed directly to the widgets
    const double caloriesEaten = 1721;
    const double caloriesGoal = 2213;
    const int proteinEaten = 78;
    const int proteinGoal = 90;
    const int fatsEaten = 45;
    const int fatsGoal = 70;
    const int carbsEaten = 95;
    const int carbsGoal = 110;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use HomeHeader widget
            HomeHeader(userName: user.name),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Use CalorieMacroCard widget
                  CalorieMacroCard(
                    // Pass the dummy data (replace with actual data later)
                    caloriesEaten: caloriesEaten,
                    caloriesGoal: caloriesGoal,
                    proteinEaten: proteinEaten,
                    proteinGoal: proteinGoal,
                    fatsEaten: fatsEaten,
                    fatsGoal: fatsGoal,
                    carbsEaten: carbsEaten,
                    carbsGoal: carbsGoal,
                  ),
                  SizedBox(height: 20),

                  // Use TargetCheckButton widget
                  TargetCheckButton(),
                  SizedBox(height: 10),

                  // Use MealTargetGrid widget
                  MealTargetGrid(),
                  // Data is currently defined inside the widget
                  SizedBox(height: 20),
                  // Increased spacing

                  // Use AddFoodButton widget
                  AddFoodButton(),
                ],
              ),
            ),
            const SizedBox(height: 40), // Bottom padding
          ],
        ),
      ),
    );
  }
}
