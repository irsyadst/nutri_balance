// Pastikan file ini ada di lib/views/widgets/meal_planner/meal_list_tile.dart
// (Kode ini sama dengan hasil refactoring food_category_screen)
import 'package:flutter/material.dart';
import '../../../models/meal_models.dart';
import '../../screens/food_detail_screen.dart';

class MealListTile extends StatelessWidget {
  final MealItem meal;
  final VoidCallback? onNotificationTap; // Callback for notification icon

  const MealListTile({
    super.key,
    required this.meal,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: Offset(0, 2))], // Softer shadow
      ),
      child: InkWell( // Make tile tappable to go to details
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailScreen(mealItem: meal)));
        },
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            // Icon Placeholder
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                // Optionally load image:
                // image: DecorationImage(image: AssetImage(meal.iconAsset), fit: BoxFit.cover),
              ),
              // Placeholder icon if no image
              child: Icon(Icons.fastfood_outlined, color: Colors.grey.shade400, size: 28),
            ),
            const SizedBox(width: 15),
            // Meal Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(meal.time, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)), // Slightly smaller time font
                ],
              ),
            ),
            // Notification Icon Button
            IconButton(
              icon: Icon(Icons.notifications_none, color: Colors.grey.shade400), // Lighter icon
              onPressed: onNotificationTap ?? () {
                // Default action if no callback provided
                print('Notification icon tapped for ${meal.name}');
              },
            ),
          ],
        ),
      ),
    );
  }
}