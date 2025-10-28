class NutritionData {
  final double calories;
  final double sugar;
  final double fiber;

  const NutritionData(this.calories, this.sugar, this.fiber);
}

class MealItem {
  final String id;
  final String name;
  final String time;
  final int calories;
  final String iconAsset;
  final String description;
  final String servingSize;
  final int protein;
  final int fat;
  final int carbs;

  const MealItem({
    required this.id,
    required this.name,
    required this.time,
    required this.calories,
    required this.iconAsset,
    this.description = '',
    this.servingSize = '1 Porsi',
    this.protein = 0,
    this.fat = 0,
    this.carbs = 0,
  });
}

class DailySchedule {
  final String mealName;
  final String time;
  final String foodName;
  final int calories;
  final String iconAsset;

  const DailySchedule({
    required this.mealName,
    required this.time,
    required this.foodName,
    required this.calories,
    required this.iconAsset,
  });
}