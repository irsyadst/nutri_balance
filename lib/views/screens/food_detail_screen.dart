import 'package:flutter/material.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'package:nutri_balance/controllers/add_food_controller.dart';
import 'package:nutri_balance/controllers/food_detail_controller.dart';
// Impor widget-widget yang sudah dipisah
import '../widgets/food_detail/food_detail_header.dart';
import '../widgets/food_detail/nutrition_info_section.dart';
import '../widgets/food_detail/log_food_button.dart';

class FoodDetailScreen extends StatefulWidget {
  final Food food;
  final AddFoodController controller; // Tetap butuh AddFoodController
  final double initialQuantity;
  final String initialMealType;

  const FoodDetailScreen({
    super.key,
    required this.food,
    required this.controller,
    this.initialQuantity = 1.0,
    this.initialMealType = 'Sarapan',
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late FoodDetailController _controller;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller baru
    _controller = FoodDetailController(
      food: widget.food,
      addFoodController: widget.controller,
      initialQuantity: widget.initialQuantity,
      initialMealType: widget.initialMealType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.food.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Stack(
        children: [
          // Konten Detail
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Gunakan Widget Header
                FoodDetailHeader(food: _controller.food),

                const Divider(height: 1, thickness: 1, indent: 24, endIndent: 24),

                // 2. Gunakan Widget Info Nutrisi
                NutritionInfoSection(food: _controller.food),
              ],
            ),
          ),

          // 3. Gunakan Widget Tombol Log
          LogFoodButton(
            onPressed: () {
              // Panggil fungsi dari controller
              _controller.showLogFoodModal(context);
            },
          )
        ],
      ),
    );
  }
}

