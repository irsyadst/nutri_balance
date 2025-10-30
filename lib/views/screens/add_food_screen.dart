// lib/views/screens/add_food_screen.dart

import 'package:flutter/material.dart';
// Import controller baru
import '../../controllers/add_food_controller.dart';
// Import widget
import '../widgets/add_food/food_search_bar.dart';
import '../widgets/add_food/recent_food_chip.dart';
import '../widgets/add_food/category_grid.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // TextEditingController tetap di state karena terkait erat dengan View
  final TextEditingController _searchController = TextEditingController();

  // Inisialisasi controller bisnis
  late AddFoodController _controller;

  // --- Data Dummy dan Logika telah dipindah ke Controller ---

  @override
  void initState() {
    super.initState();
    _controller = AddFoodController();
    _tabController = TabController(length: 1, vsync: this); // Hanya 1 tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _controller.dispose(); // Dispose controller bisnis
    super.dispose();
  }

  // --- Fungsi _handle... telah dipindah ke controller ---

  @override
  Widget build(BuildContext context) {
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Rekomendasi'),
            // Tab(text: 'Favorit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Gunakan ListenableBuilder untuk update UI dari controller
          ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              // Panggil builder tab dengan data dari controller
              return _buildRecommendationTab(context, _controller);
            },
          ),
          // _buildFavoritesTab(context),
        ],
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB REKOMENDASI ===
  // Sekarang menerima controller sebagai parameter
  Widget _buildRecommendationTab(
      BuildContext context, AddFoodController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gunakan widget FoodSearchBar
          FoodSearchBar(
            controller: _searchController,
            onChanged:
            controller.handleSearch, // Panggil method dari controller
          ),
          const SizedBox(height: 25),

          // Tampilkan bagian Terkini hanya jika tidak sedang mencari
          // Gunakan 'isSearching' dari controller
          if (!controller.isSearching) ...[
            const Text('Terkini',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              // Gunakan widget RecentFoodChip
              // Ambil data 'recentFoods' dari controller
              children: controller.recentFoods
                  .map((food) => RecentFoodChip(
                foodName: food,
                // Panggil method controller, kirim _searchController
                onTap: () => controller.handleRecentFoodTap(
                    food, _searchController),
              ))
                  .toList(),
            ),
            const SizedBox(height: 30),
          ],

          // Tampilkan Kategori hanya jika tidak sedang mencari
          if (!controller.isSearching) ...[
            const Text('Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            // Gunakan widget CategoryGrid
            CategoryGrid(
              categories:
              controller.categories, // Ambil data 'categories' dari controller
              onCategoryTap:
              controller.handleCategoryTap, // Panggil method controller
            ),
            const SizedBox(height: 30),
          ],

          // Tampilkan hasil pencarian jika sedang mencari
          if (controller.isSearching) ...[
            const Text('Hasil Pencarian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            // Tampilkan daftar hasil pencarian dari controller
            if (controller.searchResults.isEmpty)
              const Center(
                  child:
                  Text('Makanan tidak ditemukan.', style: TextStyle(color: Colors.grey))),
            // Render hasil pencarian
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.searchResults.length,
              itemBuilder: (context, index) {
                final foodName = controller.searchResults[index];
                // TODO: Ganti ini dengan widget FoodResultTile yang sesungguhnya
                return ListTile(
                  title: Text(foodName),
                  leading: const Icon(Icons.restaurant_menu),
                  onTap: () {
                    // TODO: Implementasi logika saat hasil pencarian di-tap
                    print('Memilih: $foodName');
                  },
                );
              },
            ),
          ]
        ],
      ),
    );
  }
}