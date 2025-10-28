import 'package:flutter/material.dart';
import '../../models/meal_models.dart';
import 'food_detail_screen.dart';
// Import new widgets
import '../widgets/food_category/category_search_bar.dart';
import '../widgets/food_category/horizontal_category_list.dart';
import '../widgets/food_category/recommended_food_card.dart';
import '../widgets/food_category/popular_food_tile.dart';

class FoodCategoryScreen extends StatefulWidget {
  final String mealType;
  const FoodCategoryScreen({super.key, required this.mealType});

  @override
  State<FoodCategoryScreen> createState() => _FoodCategoryScreenState();
}

class _FoodCategoryScreenState extends State<FoodCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // --- Static Example Data (Keep here or move to a controller/service) ---
  final List<MealItem> allPopularItems = const [
    MealItem(id: 'bp', name: 'Blueberry Pancake', time: '30 menit', calories: 230, iconAsset: '', protein: 10, fat: 5, carbs: 25, description: '...'),
    MealItem(id: 'sn', name: 'Salmon Nigiri', time: '20 menit', calories: 120, iconAsset: '', protein: 15, fat: 5, carbs: 5, description: '...'),
    MealItem(id: 'tr', name: 'Telur Rebus', time: '5 menit', calories: 120, iconAsset: '', protein: 8, fat: 5, carbs: 1, description: '...'),
  ];
  final List<MealItem> allRecommendedItems = const [
    MealItem(id: 'hp', name: 'Honey Pancake', time: '30 menit', calories: 180, iconAsset: '', protein: 10, fat: 5, carbs: 25, description: '...'),
    MealItem(id: 'cb', name: 'Canai Broth', time: '20 menit', calories: 230, iconAsset: '', protein: 15, fat: 10, carbs: 30, description: '...'),
  ];
  // --- End Static Data ---

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter items based on search text
  List<MealItem> get filteredPopularItems {
    if (_searchText.isEmpty) return allPopularItems;
    return allPopularItems
        .where((item) => item.name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  // Handle filter button press
  void _handleFilter() {
    // TODO: Implement filter logic (e.g., show a bottom sheet)
    print('Filter button pressed');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter logic not implemented yet.')),
    );
  }

  // Handle category tap
  void _handleCategoryTap(String categoryName) {
    // TODO: Implement category filtering or navigation
    print('Category tapped in screen: $categoryName');
    // Example: Set search text or navigate
    // _searchController.text = categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Text(widget.mealType, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton( // Use IconButton for actions
            icon: const Icon(Icons.more_horiz, color: Colors.black87),
            onPressed: () {
              // TODO: Implement more options action
            },
          ),
          const SizedBox(width: 8), // Add some padding
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use CategorySearchBar widget
            CategorySearchBar(
              controller: _searchController,
              onFilterPressed: _handleFilter,
              // onChanged: (value) => setState(() {}), // Already handled by listener
            ),
            const SizedBox(height: 20),

            // Use HorizontalCategoryList widget
            const Text('Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            HorizontalCategoryList(onCategoryTap: _handleCategoryTap),
            const SizedBox(height: 30),

            // Recommendation Section (Conditional)
            if (_searchText.isEmpty) ...[
              const Text('Rekomendasi untuk Diet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildRecommendedCarousel(context), // Keep this builder for the carousel structure
              const SizedBox(height: 30),
            ],

            // Popular / Search Results Section
            Text(_searchText.isEmpty ? 'Popular' : 'Hasil Pencarian', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            // Use ListView.builder for potentially long lists
            ListView.builder(
              shrinkWrap: true, // Important inside SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
              itemCount: filteredPopularItems.length,
              itemBuilder: (context, index) {
                // Use PopularFoodTile widget
                return PopularFoodTile(item: filteredPopularItems[index]);
              },
            ),
            // Fallback if no results
            if (_searchText.isNotEmpty && filteredPopularItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: Text('Tidak ada hasil ditemukan.', style: TextStyle(color: Colors.grey))),
              ),

            const SizedBox(height: 50), // Bottom padding
          ],
        ),
      ),
    );
  }

  // === WIDGET BUILDER FOR CAROUSEL (Kept here as it structures the list) ===
  Widget _buildRecommendedCarousel(BuildContext context) {
    return SizedBox(
      height: 250, // Height of the carousel
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allRecommendedItems.length,
        itemBuilder: (context, index) {
          final item = allRecommendedItems[index];
          // Alternate background colors
          Color bgColor = index % 2 == 0 ? const Color(0xFFE0F7FA) : const Color(0xFFF3E5F5);
          Color btnStartColor = index % 2 == 0 ? const Color(0xFF007BFF) : const Color(0xFF9C27B0);

          // Use RecommendedFoodCard widget
          return RecommendedFoodCard(
            item: item,
            backgroundColor: bgColor,
            buttonStartColor: btnStartColor,
          );
        },
      ),
    );
  }
}