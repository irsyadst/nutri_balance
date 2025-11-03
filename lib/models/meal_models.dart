import 'dart:convert';

// Model ini untuk data makanan yang ada di dalam MealPlan
// Strukturnya harus cocok dengan 'foodModel.js' di backend
class Food {
  final String id;
  final String name;
  final int calories;
  final double proteins;
  final double carbs;
  final double fats;
  final String category;
  final double servingQuantity;
  final String servingUnit;

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.category,
    required this.servingQuantity,
    required this.servingUnit,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown Food',
      calories: (json['calories'] ?? 0).toInt(),
      proteins: (json['proteins'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fats: (json['fats'] ?? 0.0).toDouble(),
      category: json['category'] ?? 'Uncategorized',
      servingQuantity: (json['servingQuantity'] ?? 1.0).toDouble(),
      servingUnit: json['servingUnit'] ?? 'porsi',
    );
  }
}

class MealPlan {
  final String id;
  final String date;
  final String mealType;
  final String time;
  final Food food;
  final double quantity;
  final double displayQuantity;
  final String displayUnit;

  MealPlan({
    required this.id,
    required this.date,
    required this.mealType,
    required this.time,
    required this.food,
    required this.quantity,
    required this.displayQuantity,
    required this.displayUnit,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    final foodData = json['food'];
    Food parsedFood;

    if (foodData is Map<String, dynamic>) {
      parsedFood = Food.fromJson(foodData);
    } else {
      parsedFood = Food.fromJson({}); // Buat food kosong jika error
    }

    final qtyAsDouble = (json['quantity'] ?? 1.0).toDouble();

    return MealPlan(
      id: json['_id'] ?? '',
      date: json['date'] ?? '',
      mealType: json['mealType'] ?? 'Unknown Meal',
      time: json['time'] ?? '00:00',
      food: parsedFood,
      quantity: (json['quantity'] ?? 1.0).toDouble(),
      displayQuantity: (json['displayQuantity'] ?? qtyAsDouble).toDouble(),
      displayUnit: json['displayUnit'] ?? parsedFood.servingUnit,
    );
  }
}

// Helper function untuk parsing List
List<MealPlan> mealPlanFromJson(String str) => List<MealPlan>.from(
    json.decode(str).map((x) => MealPlan.fromJson(x)));