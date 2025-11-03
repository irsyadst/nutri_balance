// lib/models/food_log_model.dart

// Model untuk detail makanan di dalam log
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

  // Konversi dari Map (JSON)
  factory LoggedFood.fromJson(Map<String, dynamic> json) {
    return LoggedFood(
      id: json['id'], // ID mungkin string atau null
      name: json['name'] ?? 'Makanan Tidak Dikenal', // Default name
      calories: (json['calories'] ?? 0.0).toDouble(), // Konversi aman ke double
      proteins: (json['proteins'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fats: (json['fats'] ?? 0.0).toDouble(),
      servingQuantity: (json['servingQuantity'] ?? 1.0).toDouble(),
      servingUnit: json['servingUnit'] ?? 'porsi',
    );
  }
}


class FoodLogEntry {
  final String id; // ID log dari MongoDB
  final dynamic userId; // Bisa String atau Object (jika populate)
  final String date; // Tanggal log (YYYY-MM-DD)
  final LoggedFood food; // Detail makanan yang dicatat
  final double quantity; // Jumlah porsi/gram
  final String mealType; // Sarapan, Makan Siang, dll.
  final DateTime createdAt; // Waktu pencatatan
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

  // Factory constructor untuk membuat instance dari JSON
  factory FoodLogEntry.fromJson(Map<String, dynamic> json) {
    // Handle userId yang mungkin object atau string
    dynamic userIdData = json['userId'];
    String userIdString = '';
    if (userIdData is String) {
      userIdString = userIdData;
    } else if (userIdData is Map && userIdData.containsKey('_id')) {
      userIdString = userIdData['_id']; // Ambil _id jika dipopulate
    }

    final qtyAsDouble = (json['quantity'] ?? 1.0).toDouble();

    return FoodLogEntry(
      id: json['_id'] ?? '', // ID log
      userId: userIdString,
      date: json['date'] ?? '', // Tanggal string
      food: LoggedFood.fromJson(json['food'] ?? {}), // Parse sub-objek food
      quantity: (json['quantity'] ?? 1.0).toDouble(), // Konversi quantity ke double, default 1
      mealType: json['mealType'] ?? 'Lainnya', // Default meal type
      // Parse createdAt, beri default jika gagal parse
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      displayQuantity: (json['displayQuantity'] ?? qtyAsDouble).toDouble(),
      displayUnit: json['displayUnit'] ?? json['food']?['servingUnit'] ?? 'porsi',
    );
  }
}