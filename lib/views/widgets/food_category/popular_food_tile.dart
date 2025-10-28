import 'package:flutter/material.dart';
import '../../../models/meal_models.dart'; // Assuming MealItem is here
import '../../screens/food_detail_screen.dart'; // To navigate on tap

class PopularFoodTile extends StatelessWidget {
  final MealItem item;

  const PopularFoodTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder for difficulty level (you might want to add this to MealItem)
    const level = 'Sedang';

    return ListTile(
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        // child: Image.asset(item.iconAsset), // If you have images
        child: Icon(Icons.ramen_dining, color: Colors.grey.shade400, size: 30), // Placeholder icon
      ),
      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        '$level | ${item.time} | ${item.calories} kkal',
        style: TextStyle(color: Colors.grey.shade600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF007BFF)),
      onTap: () {
        // Navigate to Food Detail Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodDetailScreen(mealItem: item)),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8), // Adjust padding
    );
  }
}