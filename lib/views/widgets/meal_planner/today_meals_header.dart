import 'package:flutter/material.dart';
import '../../screens/food_category_screen.dart'; // For navigation

// Header for the "Today Meals" section with a dropdown
class TodayMealsHeader extends StatelessWidget {
  // Pass the initial dropdown value and callback from the screen
  final String selectedMealType;
  final ValueChanged<String?> onMealTypeChanged;

  const TodayMealsHeader({
    super.key,
    required this.selectedMealType,
    required this.onMealTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Today Meals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // Dropdown to select meal type and navigate
        DropdownButton<String>(
          value: selectedMealType, // Use value from parameter
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF007BFF)),
          underline: const SizedBox(), // Hide default underline
          style: const TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold, fontSize: 16),
          // Define dropdown items
          items: <String>['Sarapan', 'Makan Siang', 'Makan Malam', 'Snack'] // Add Snack if needed
              .map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          // Use callback from parameter and navigate
          onChanged: (String? newValue) {
            if (newValue != null) {
              onMealTypeChanged(newValue); // Update state in the parent screen
              // Navigate to Food Category Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FoodCategoryScreen(mealType: newValue)),
              );
            }
          },
        ),
      ],
    );
  }
}