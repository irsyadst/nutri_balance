import 'package:flutter/material.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'package:nutri_balance/controllers/add_food_controller.dart';
import 'package:nutri_balance/controllers/food_detail_controller.dart';
import '../widgets/food_detail/food_detail_header.dart';
import '../widgets/food_detail/nutrition_info_section.dart';
import '../widgets/food_detail/log_food_button.dart';

class FoodDetailScreen extends StatefulWidget {
  final Food food;
  final AddFoodController? controller;
  final double initialQuantity;
  final String initialMealType;

  const FoodDetailScreen({
    super.key,
    required this.food,
    this.controller,
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
                FoodDetailHeader(food: _controller.food),
                const Divider(height: 1, thickness: 1, indent: 24, endIndent: 24),
                NutritionInfoSection(food: _controller.food),
              ],
            ),
          ),

          if (widget.controller != null)
            LogFoodButton(
              onPressed: () {
                _controller.showLogFoodModal(context);
              },
            )
        ],
      ),
    );
  }
}