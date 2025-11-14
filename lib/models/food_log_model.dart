class LoggedFood {
  final String? id;
  final String name;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final double servingQuantity;
  final String servingUnit;

  LoggedFood({
    this.id,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.servingQuantity,
    required this.servingUnit,
  });

  factory LoggedFood.fromJson(Map<String, dynamic> json) {
    return LoggedFood(
      id: json['id'],
      name: json['name'] ?? 'Makanan Tidak Dikenal',
      calories: (json['calories'] ?? 0.0).toDouble(),
      proteins: (json['proteins'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fats: (json['fats'] ?? 0.0).toDouble(),
      servingQuantity: (json['servingQuantity'] ?? 1.0).toDouble(),
      servingUnit: json['servingUnit'] ?? 'porsi',
    );
  }
}


class FoodLogEntry {
  final String id;
  final dynamic userId;
  final String date;
  final LoggedFood food;
  final double quantity;
  final String mealType;
  final DateTime createdAt;
  final double displayQuantity;
  final String displayUnit;

  FoodLogEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.food,
    required this.quantity,
    required this.mealType,
    required this.createdAt,
    required this.displayQuantity,
    required this.displayUnit,
  });

  factory FoodLogEntry.fromJson(Map<String, dynamic> json) {
    dynamic userIdData = json['userId'];
    String userIdString = '';
    if (userIdData is String) {
      userIdString = userIdData;
    } else if (userIdData is Map && userIdData.containsKey('_id')) {
      userIdString = userIdData['_id'];
    }

    final qtyAsDouble = (json['quantity'] ?? 1.0).toDouble();

    return FoodLogEntry(
      id: json['_id'] ?? '',
      userId: userIdString,
      date: json['date'] ?? '',
      food: LoggedFood.fromJson(json['food'] ?? {}),
      quantity: (json['quantity'] ?? 1.0).toDouble(),
      mealType: json['mealType'] ?? 'Lainnya',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      displayQuantity: (json['displayQuantity'] ?? qtyAsDouble).toDouble(),
      displayUnit: json['displayUnit'] ?? json['food']?['servingUnit'] ?? 'porsi',
    );
  }
}