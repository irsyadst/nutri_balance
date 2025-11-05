// lib/views/widgets/add_food/category_tab_view.dart

import 'package:flutter/material.dart';
import '../../../controllers/add_food_controller.dart';
import 'category_grid.dart';

class CategoryTabView extends StatelessWidget {
  final AddFoodController controller;
  final TextEditingController searchController;

  const CategoryTabView({
    super.key,
    required this.controller,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.status == AddFoodStatus.loading &&
        controller.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.status == AddFoodStatus.error &&
        controller.categories.isEmpty) {
      return Center(
          child: Text(controller.errorMessage,
              style: const TextStyle(color: Colors.red)));
    }

    // Bungkus dengan SingleChildScrollView agar bisa di-scroll
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryGrid(
            categories: controller.categories,
            onCategoryTap: (categoryName) =>
                controller.handleSearchByCategory(categoryName, searchController),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}