// lib/controllers/add_food_controller.dart
import 'package:flutter/material.dart';

// Enum untuk status, bisa dikembangkan saat mengambil data dari API
enum AddFoodStatus { initial, loading, success, failure }

class AddFoodController with ChangeNotifier {
  // --- State ---
  AddFoodStatus _status = AddFoodStatus.initial;
  String _searchQuery = '';

  // Data (dummy, ganti dengan fetch API nanti)
  List<String> _recentFoods = [];
  List<Map<String, dynamic>> _categories = [];
  List<String> _searchResults = []; // Untuk menampung hasil pencarian

  // --- Getters untuk UI ---
  AddFoodStatus get status => _status;
  List<String> get recentFoods => List.unmodifiable(_recentFoods);
  List<Map<String, dynamic>> get categories => List.unmodifiable(_categories);
  List<String> get searchResults => List.unmodifiable(_searchResults);

  // Getter untuk menentukan apakah UI harus menampilkan hasil pencarian
  bool get isSearching => _searchQuery.isNotEmpty;
  String get searchQuery => _searchQuery;

  // --- Constructor ---
  AddFoodController() {
    // Muat data awal saat controller dibuat
    _fetchInitialData();
  }

  // --- Logika Pengambilan Data ---
  void _fetchInitialData() {
    _status = AddFoodStatus.loading;
    // Simulasi fetch data
    try {
      // Data dummy
      _recentFoods = [
        'Dada ayam',
        'Beras merah',
        'Brokoli',
        'Alpukat',
        'Ikan salmon'
      ];
      _categories = [
        {'name': 'Salad', 'icon': Icons.spa_outlined},
        {'name': 'Buah-buahan', 'icon': Icons.apple_outlined},
        {'name': 'Sayuran', 'icon': Icons.local_florist_outlined},
        {'name': 'Daging', 'icon': Icons.kebab_dining_outlined},
        {'name': 'Produk susu', 'icon': Icons.egg_alt_outlined},
        {'name': 'Biji-bijian', 'icon': Icons.grain_outlined},
      ];
      _status = AddFoodStatus.success;
    } catch (e) {
      _status = AddFoodStatus.failure;
    }
    // Tidak perlu notifyListeners() di sini karena ini di constructor,
    // tapi jika ini adalah fungsi async, Anda harus memanggilnya.
  }

  // --- Event Handler (Dipanggil oleh View) ---

  /// Dipanggil saat teks di search bar berubah
  void handleSearch(String query) {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      _searchResults = [];
    } else {
      // Logika pencarian (dummy): filter dari recent foods
      _searchResults = _recentFoods
          .where(
              (food) => food.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
      // TODO: Ganti ini dengan panggilan API untuk pencarian makanan
    }

    notifyListeners(); // Beri tahu UI untuk update
  }

  /// Dipanggil saat chip makanan terkini di-tap
  void handleRecentFoodTap(
      String foodName, TextEditingController searchController) {
    // Set teks di search bar (yang ada di view)
    searchController.text = foodName;
    // Pindahkan cursor ke akhir
    searchController.selection =
        TextSelection.fromPosition(TextPosition(offset: foodName.length));
    // Panggil handleSearch untuk memicu UI pencarian
    handleSearch(foodName);
  }

  /// Dipanggil saat kartu kategori di-tap
  void handleCategoryTap(String categoryName) {
    // TODO: Implementasi navigasi ke halaman detail kategori atau filter makanan
    print('Kategori diklik: $categoryName');
    // Contoh:
    // _navigationService.navigateTo(Routes.categoryDetail, arguments: categoryName);
  }
}