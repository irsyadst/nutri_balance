import 'package:flutter/material.dart';

import '../../models/meal_models.dart';
// Import new widgets
import '../widgets/meal_planner/nutrition_chart_section.dart';
import '../widgets/meal_planner/daily_schedule_card_button.dart';
import '../widgets/meal_planner/today_meals_header.dart';
import '../widgets/meal_planner/meal_list_tile.dart'; // Ensure correct path
import '../widgets/meal_planner/find_food_section.dart';

class MealPlannerScreen extends StatefulWidget { // Changed to StatefulWidget for dropdown state
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> { // State class
  // --- Data Dummy (Ideally from state management) ---
  final List<MealItem> todayMeals = const [
    MealItem(id: '1', name: 'Salmon Nigiri', time: 'Hari ini | Jam 7 pagi', calories: 300, iconAsset: '', protein: 30, fat: 15, carbs: 20),
    MealItem(id: '2', name: 'Susu Rendah Lemak', time: 'Hari ini | Jam 8 pagi', calories: 120, iconAsset: '', protein: 8, fat: 2, carbs: 10),
    // Add more dummy meals if needed
  ];
  // --- End Data Dummy ---

  // State for the dropdown in TodayMealsHeader
  String _selectedMealType = 'Sarapan';

  // Function to handle dropdown changes
  void _handleMealTypeChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedMealType = newValue;
      });
    }
  }

  // Function to handle daily schedule card tap
  void _handleDailyScheduleTap() {
    // TODO: Navigate to the daily schedule screen or perform an action
    print("Daily Schedule Card Tapped!");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigasi Jadwal Harian belum diimplementasi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Keep AppBar simple, title only
        title: const Text('Meal Planner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87)), // Slightly smaller title
        centerTitle: false, // Align title left
        backgroundColor: Colors.white,
        elevation: 0, // No shadow
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Add vertical padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use NutritionChartSection widget
            const NutritionChartSection(),
            const SizedBox(height: 30),

            // Use DailyScheduleCardButton widget
            DailyScheduleCardButton(onPressed: _handleDailyScheduleTap),
            const SizedBox(height: 30),

            // Use TodayMealsHeader widget
            TodayMealsHeader(
              selectedMealType: _selectedMealType,
              onMealTypeChanged: _handleMealTypeChange,
            ),
            const SizedBox(height: 15),

            // Today Meals List using MealListTile
            // Use ListView.builder if the list can be long
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todayMeals.length,
              itemBuilder: (context, index) => MealListTile(meal: todayMeals[index]),
            ),
            // ...todayMeals.map((meal) => MealListTile(meal: meal)).toList(), // Alternative without ListView
            const SizedBox(height: 30), // Adjusted spacing

            // Use FindFoodSection widget
            const FindFoodSection(),
            const SizedBox(height: 40), // Bottom padding
          ],
        ),
      ),
    );
  }
}