// lib/views/widgets/add_food/search_results_view.dart

import 'package:flutter/material.dart';
import '../../../controllers/add_food_controller.dart';
import 'food_result_tile.dart';
import '../../screens/food_detail_screen.dart';

class SearchResultsView extends StatelessWidget {
  final AddFoodController controller;

  const SearchResultsView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Tampilkan hasil pencarian
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hasil Pencarian',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          if (controller.status == AddFoodStatus.loading)
            const Center(child: CircularProgressIndicator()),
          if (controller.status == AddFoodStatus.error)
            Center(
                child: Text(controller.errorMessage,
                    style: const TextStyle(color: Colors.red))),
          if (controller.status == AddFoodStatus.success) ...[
            if (controller.searchResults.isEmpty)
              const Center(
                  child: Text('Makanan tidak ditemukan.',
                      style: TextStyle(color: Colors.grey))),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final food = controller.searchResults[index];
                  return FoodResultTile(
                    food: food,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetailScreen(
                            food: food,
                            controller: controller,
                            initialQuantity: 1.0,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }
}