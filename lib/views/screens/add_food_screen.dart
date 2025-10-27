import 'package:flutter/material.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Data Dummy
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
    _tabController = TabController(length: 2, vsync: this);
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Rekomendasi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecommendationTab(context),
        ],
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB REKOMENDASI ===
  Widget _buildRecommendationTab(BuildContext context) {
    // ... (Kode untuk tab rekomendasi - tidak berubah) ...
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 25),
          const Text('Terkini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: recentFoods.map((food) => _buildRecentFoodChip(food)).toList(),
          ),
          const SizedBox(height: 30),
          const Text('Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _buildCategoryGrid(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    // ... (Kode search bar - tidak berubah) ...
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Cari makanan',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFF3F4F6), // Warna abu muda
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onChanged: (value) {
        // TODO: Implementasi logika pencarian
        print('Mencari: $value');
      },
    );
  }

  Widget _buildRecentFoodChip(String foodName) {
    // ... (Kode chip - tidak berubah) ...
    return Chip(
      label: Text(foodName, style: TextStyle(color: Colors.grey.shade700)),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    // ... (Kode grid kategori - tidak berubah) ...
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          context,
          category['name'],
          category['icon'],
        );
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, String name, IconData icon) {
    // ... (Kode kartu kategori - tidak berubah) ...
    return InkWell( // Bungkus dengan InkWell agar bisa diklik
      onTap: () {
        // TODO: Navigasi ke halaman detail kategori atau lakukan aksi lain
        print('Kategori diklik: $name');
      },
      borderRadius: BorderRadius.circular(15), // Efek ripple mengikuti bentuk
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Placeholder untuk gambar kategori (ganti dengan Image.asset jika ada)
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade100,
              child: Icon(icon, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
            Expanded( // Agar teks tidak overflow
              child: Text(
                name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis, // Atasi jika teks terlalu panjang
              ),
            ),
          ],
        ),
      ),
    );
  }
}