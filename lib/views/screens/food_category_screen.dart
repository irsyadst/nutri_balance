import 'package:flutter/material.dart';
import '../../models/meal_models.dart';
import 'food_detail_screen.dart'; 

class FoodCategoryScreen extends StatefulWidget {
  final String mealType;
  const FoodCategoryScreen({super.key, required this.mealType});

  @override
  State<FoodCategoryScreen> createState() => _FoodCategoryScreenState();
}

class _FoodCategoryScreenState extends State<FoodCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // Data Contoh Statis
  final List<MealItem> allPopularItems = const [
    MealItem(
      id: 'bp', 
      name: 'Blueberry Pancake', 
      time: '30 menit', 
      calories: 230, 
      iconAsset: 'assets/images/blueberry_pancake.png', 
      protein: 10, fat: 5, carbs: 25,
      description: 'Pancake blueberry klasik yang lezat.',
    ),
    MealItem(
      id: 'sn', 
      name: 'Salmon Nigiri', 
      time: '20 menit', 
      calories: 120, 
      iconAsset: 'assets/images/salmon_nigiri.png', 
      protein: 15, fat: 5, carbs: 5,
      description: 'Nigiri salmon segar yang cocok untuk makan malam ringan.',
    ),
    MealItem(
      id: 'tr', 
      name: 'Telur Rebus', 
      time: '5 menit', 
      calories: 120, 
      iconAsset: 'assets/images/boiled_egg.png', 
      protein: 8, fat: 5, carbs: 1,
      description: 'Sumber protein cepat dan mudah.',
    ),
  ];

  final List<MealItem> allRecommendedItems = const [
    MealItem(
      id: 'hp', 
      name: 'Honey Pancake', 
      time: '30 menit', 
      calories: 180, 
      iconAsset: 'assets/images/honey_pancake.png', 
      protein: 10, fat: 5, carbs: 25,
      description: 'Pancake dengan madu alami, pilihan diet yang lebih sehat.',
    ),
    MealItem(
      id: 'cb', 
      name: 'Canai Broth', 
      time: '20 menit', 
      calories: 230, 
      iconAsset: 'assets/images/canai_broth.png', 
      protein: 15, fat: 10, carbs: 30,
      description: 'Kuah canai yang hangat dan mengenyangkan.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter Items berdasarkan teks pencarian
  List<MealItem> get filteredPopularItems {
    if (_searchText.isEmpty) {
      return allPopularItems;
    }
    return allPopularItems
        .where((item) => item.name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text(widget.mealType, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 20),
            
            // Kategori
            const Text('Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildCategoryRow(),
            const SizedBox(height: 30),

            // Rekomendasi untuk Diet (Disembunyikan saat mencari)
            if (_searchText.isEmpty) ...[
              const Text('Rekomendasi untuk Diet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildRecommendedCarousel(context),
              const SizedBox(height: 30),
            ],

            // Popular Section
            Text(_searchText.isEmpty ? 'Popular' : 'Hasil Pencarian', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ...filteredPopularItems.map((item) => _buildPopularTile(context, item)).toList(),
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // === WIDGET PEMBANGUN (BUILDERS) ===

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Pancake', // Diperbaiki agar sesuai gambar
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: const Icon(Icons.tune, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCategoryRow() {
    final categories = [
      {'name': 'Salad', 'bgColor': const Color(0xFFE8F5E9)},
      {'name': 'Kue', 'bgColor': const Color(0xFFF3E5F5)},
      {'name': 'Pie', 'bgColor': const Color(0xFFE0F7FA)},
      {'name': 'Smoothies', 'bgColor': const Color(0xFFFFF3E0)},
    ];
    
    // Placeholder Icon untuk kategori
    final categoryIcons = [Icons.lunch_dining, Icons.cake, Icons.pie_chart, Icons.blender];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 15),
            child: Column(
              children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    color: cat['bgColor'] as Color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(categoryIcons[index], color: Colors.grey.shade700),
                ),
                const SizedBox(height: 5),
                Text(cat['name'] as String, style: const TextStyle(fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedCarousel(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allRecommendedItems.length,
        itemBuilder: (context, index) {
          final item = allRecommendedItems[index];
          
          Color bgColor = index % 2 == 0 ? const Color(0xFFE0F7FA) : const Color(0xFFF3E5F5); // Warna latar belakang berbeda
          Color btnStartColor = index % 2 == 0 ? const Color(0xFF007BFF) : const Color(0xFF9C27B0);
          
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Gambar Makanan Placeholder
                Center(
                  child: Container(
                    width: 150, height: 100,
                    // Menggunakan placeholder image untuk Honey Pancake
                    child: const Icon(Icons.fastfood, size: 60, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Mudah | ${item.time} | ${item.calories} kkal', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                
                // Tombol Lihat dengan Gradient
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [btnStartColor.withOpacity(0.8), btnStartColor.withOpacity(0.5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailScreen(mealItem: item)));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      ),
                      child: const Text('Lihat', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularTile(BuildContext context, MealItem item) {
    // Placeholder untuk level kesulitan (diasumsikan 'Sedang')
    final level = 'Sedang';
    
    return ListTile(
      leading: Container(
        width: 60, height: 60,
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.ramen_dining, color: Colors.grey),
      ),
      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$level | ${item.time} | ${item.calories} kkal', style: TextStyle(color: Colors.grey.shade600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF007BFF)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailScreen(mealItem: item)));
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    );
  }
}