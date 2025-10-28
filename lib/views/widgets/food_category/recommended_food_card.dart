import 'package:flutter/material.dart';
import '../../../models/meal_models.dart'; // Assuming MealItem is here
import '../../screens/food_detail_screen.dart'; // To navigate on button press

class RecommendedFoodCard extends StatelessWidget {
  final MealItem item;
  final Color backgroundColor;
  final Color buttonStartColor;

  const RecommendedFoodCard({
    super.key,
    required this.item,
    required this.backgroundColor,
    required this.buttonStartColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Fixed width for carousel items
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
        children: [
          // Food Image Placeholder
          Center(
            child: Container(
              width: 150, // Adjust size as needed
              height: 100, // Adjust size as needed
              decoration: BoxDecoration(
                // You can add an image here later
                color: Colors.white.withOpacity(0.5), // Placeholder color
                borderRadius: BorderRadius.circular(15),
              ),
              // child: Image.asset(item.iconAsset, fit: BoxFit.cover), // If you have images
              child: Icon(Icons.fastfood, size: 60, color: Colors.grey.shade400), // Placeholder icon
            ),
          ),
          const SizedBox(height: 10),
          // Food Details
          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(
            'Mudah | ${item.time} | ${item.calories} kkal', // Example details
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),

          // View Button
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  // Use buttonStartColor for gradient
                  colors: [buttonStartColor.withOpacity(0.8), buttonStartColor.withOpacity(0.5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  // Navigate to Food Detail Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoodDetailScreen(mealItem: item)),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text('Lihat', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}