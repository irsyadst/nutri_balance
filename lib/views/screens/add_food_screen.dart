import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_balance/models/meal_models.dart';
import '../../controllers/add_food_controller.dart';
import '../widgets/add_food/food_search_bar.dart';
import '../widgets/add_food/category_grid.dart';
// Impor widget baru
import '../widgets/add_food/food_result_tile.dart';
import '../widgets/add_food/log_food_modal.dart';
// --- IMPOR BARU ---
import 'food_detail_screen.dart';
// --- AKHIR IMPOR BARU ---


class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  late AddFoodController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddFoodController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// ... (build method tetap sama)
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Tambah Makanan',
            style:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return _buildBody(context, _controller);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AddFoodController controller) {
// ... (Fungsi _buildBody tetap sama)
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FoodSearchBar(
            controller: _searchController,
            onChanged:
            controller.handleSearchByName, // Panggil method pencarian nama
          ),
          const SizedBox(height: 25),
          _buildContent(context, controller)
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AddFoodController controller) {
    if (controller.isSearching) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hasil Pencarian',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          if (controller.status == AddFoodStatus.loading)
            const Center(child: CircularProgressIndicator()),

          if (controller.status == AddFoodStatus.error)
            Center(child: Text(controller.errorMessage, style: const TextStyle(color: Colors.red))),

          if (controller.status == AddFoodStatus.success) ...[
            if (controller.searchResults.isEmpty)
              const Center(
                  child:
                  Text('Makanan tidak ditemukan.', style: TextStyle(color: Colors.grey))),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.searchResults.length,
              itemBuilder: (context, index) {
                final food = controller.searchResults[index];
                return FoodResultTile(
                  food: food,
                  // --- PERBAIKAN: Navigasi ke Detail Screen ---
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailScreen(
                          food: food,
                          controller: controller,
                          // Kita tidak tahu meal type/qty di sini, jadi pakai default
                          initialQuantity: 1.0,
                        ),
                      ),
                    );
                  },
                  // --- AKHIR PERBAIKAN ---
                );
              },
            ),
          ]
        ],
      );
    }

    if (controller.status == AddFoodStatus.loading && controller.recommendedFoods.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.status == AddFoodStatus.error && controller.recommendedFoods.isEmpty) {
      return Center(child: Text(controller.errorMessage, style: const TextStyle(color: Colors.red)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rekomendasi Hari Ini',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        if (controller.recommendedFoods.isEmpty)
          const Center(
              child: Text('Tidak ada rekomendasi hari ini.', style: TextStyle(color: Colors.grey))),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recommendedFoods.length,
          itemBuilder: (context, index) {
            final meal = controller.recommendedFoods[index];
            final food = meal.food;
            final subtitle = '${meal.displayQuantity.toStringAsFixed(0)} ${meal.displayUnit} • ${meal.mealType}';

            return FoodResultTile(
              food: food,
              subtitle: subtitle,
              // --- PERBAIKAN: Navigasi ke Detail Screen ---
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailScreen(
                      food: food,
                      controller: controller,
                      // Kirim data rekomendasi ke detail screen
                      initialQuantity: meal.quantity,
                      initialMealType: meal.mealType,
                    ),
                  ),
                );
              },
              // --- AKHIR PERBAIKAN ---
            );
          },
        ),
        const SizedBox(height: 30),

        const Text('Kategori',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        CategoryGrid(
          categories:
          controller.categories,
          onCategoryTap: (categoryName) => controller.handleSearchByCategory(categoryName, _searchController),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

