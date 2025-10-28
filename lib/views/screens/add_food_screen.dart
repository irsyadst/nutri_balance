import 'package:flutter/material.dart';
// Import widget yang baru
import '../widgets/add_food/food_search_bar.dart';
import '../widgets/add_food/recent_food_chip.dart';
import '../widgets/add_food/category_grid.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Data Dummy (biarkan di sini atau pindahkan ke controller/state management)
  final List<String> recentFoods = ['Dada ayam', 'Beras merah', 'Brokoli', 'Alpukat', 'Ikan salmon'];
  final List<Map<String, dynamic>> categories = [
    {'name': 'Salad', 'icon': Icons.spa_outlined},
    {'name': 'Buah-buahan', 'icon': Icons.apple_outlined},
    {'name': 'Sayuran', 'icon': Icons.local_florist_outlined},
    {'name': 'Daging', 'icon': Icons.kebab_dining_outlined},
    {'name': 'Produk susu', 'icon': Icons.egg_alt_outlined},
    {'name': 'Biji-bijian', 'icon': Icons.grain_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this); // Hanya 1 tab sekarang
  }

  @override
  void dispose() { // Jangan lupa dispose controller
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani perubahan teks pencarian
  void _handleSearch(String query) {
    // TODO: Implementasi logika pencarian di sini
    print('Mencari: $query');
    // Anda mungkin perlu memfilter daftar makanan berdasarkan query
    // dan memperbarui UI (jika menggunakan state management)
  }

  // Fungsi untuk menangani tap pada chip recent food
  void _handleRecentFoodTap(String foodName) {
    // TODO: Lakukan sesuatu saat chip makanan terkini diklik,
    // misal mengisi search bar atau langsung menambahkan
    print('Chip terkini diklik: $foodName');
    _searchController.text = foodName; // Contoh: isi search bar
    _handleSearch(foodName);
  }

  // Fungsi untuk menangani tap pada kartu kategori
  void _handleCategoryTap(String categoryName) {
    // TODO: Navigasi ke halaman detail kategori atau filter makanan
    print('Kategori diklik: $categoryName');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailScreen(categoryName: categoryName)));
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
        title: const Text('Tambah Makanan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar( // TabBar tetap ada meskipun hanya 1 tab
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey, // Tidak akan terlihat dengan 1 tab
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Rekomendasi'),
            // Tambahkan tab lain di sini jika perlu di masa depan
            // Tab(text: 'Favorit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecommendationTab(context), // Panggil builder tab
          // Tambahkan view untuk tab lain di sini
          // _buildFavoritesTab(context),
        ],
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB REKOMENDASI ===
  Widget _buildRecommendationTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gunakan widget FoodSearchBar
          FoodSearchBar(
            controller: _searchController,
            onChanged: _handleSearch,
          ),
          const SizedBox(height: 25),

          // Tampilkan bagian Terkini hanya jika tidak sedang mencari
          if (_searchController.text.isEmpty) ...[
            const Text('Terkini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              // Gunakan widget RecentFoodChip
              children: recentFoods.map((food) => RecentFoodChip(
                foodName: food,
                onTap: () => _handleRecentFoodTap(food), // Tambahkan onTap
              )).toList(),
            ),
            const SizedBox(height: 30),
          ],

          // Tampilkan Kategori hanya jika tidak sedang mencari
          if (_searchController.text.isEmpty) ...[
            const Text('Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            // Gunakan widget CategoryGrid
            CategoryGrid(
              categories: categories,
              onCategoryTap: _handleCategoryTap, // Tambahkan onCategoryTap
            ),
            const SizedBox(height: 30),
          ],

          // Tampilkan hasil pencarian jika ada teks di search bar
          if (_searchController.text.isNotEmpty) ...[
            const Text('Hasil Pencarian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            // TODO: Tampilkan daftar hasil pencarian di sini
            // Misalnya menggunakan ListView.builder
            // Contoh:
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: searchResults.length, // searchResults didapat dari state
            //   itemBuilder: (context, index) {
            //     final foodItem = searchResults[index];
            //     return FoodResultTile(food: foodItem); // Buat widget FoodResultTile
            //   },
            // ),
            const Center(child: Text('Tampilkan hasil pencarian di sini...')), // Placeholder
          ]
        ],
      ),
    );
  }

}