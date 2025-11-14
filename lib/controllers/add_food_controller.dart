import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_balance/models/api_service.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'package:nutri_balance/models/storage_service.dart';

enum AddFoodStatus { initial, loading, success, error }

class AddFoodController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // --- STATE DATA ---
  AddFoodStatus _status = AddFoodStatus.initial;
  AddFoodStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // --- STATE UI ---
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  // --- DATA LISTS ---
  List<MealPlan> _recommendedFoods = [];
  List<MealPlan> get recommendedFoods => _recommendedFoods;

  List<Food> _searchResults = [];
  List<Food> get searchResults => _searchResults;

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> get categories => _categories;


  AddFoodController() {
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    _status = AddFoodStatus.loading;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      final categoryNames = await _apiService.getFoodCategories();
      _categories = categoryNames.map((name) {
        IconData icon;
        switch (name) {
          case 'Karbohidrat':
            icon = Icons.rice_bowl_outlined;
            break;
          case 'Protein Hewani':
            icon = Icons.kebab_dining_outlined;
            break;
          case 'Protein Nabati':
            icon = Icons.eco_outlined;
            break;
          case 'Sayuran':
            icon = Icons.local_florist_outlined;
            break;
          case 'Buah':
            icon = Icons.apple_outlined;
            break;
          case 'Susu & Olahan':
            icon = Icons.egg_alt_outlined;
            break;
          case 'Minuman':
            icon = Icons.local_cafe_outlined;
            break;
          default:
            icon = Icons.fastfood_outlined;
        }
        return {'name': name, 'icon': icon};
      }).toList();

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _recommendedFoods = await _apiService.getMealPlan(token, today);

      _status = AddFoodStatus.success;
    } catch (e) {
      _errorMessage = "Gagal memuat data: $e";
      _status = AddFoodStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> handleSearchByName(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _status = AddFoodStatus.loading;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchFoods(searchQuery: query);
      _status = AddFoodStatus.success;
    } catch (e) {
      _errorMessage = "Gagal mencari makanan: $e";
      _status = AddFoodStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> handleSearchByCategory(String categoryName, TextEditingController searchController) async {

    searchController.text = categoryName;

    _isSearching = true;
    _status = AddFoodStatus.loading;
    notifyListeners();

    try {
      // 2. Panggil API hanya dengan parameter kategori
      _searchResults = await _apiService.searchFoods(category: categoryName);
      _status = AddFoodStatus.success;
    } catch (e) {
      _errorMessage = "Gagal memuat kategori: $e";
      _status = AddFoodStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> logFood({
    required String foodId,
    required double quantity,
    required String mealType,
    required String date,
  }) async {
    _status = AddFoodStatus.loading;
    notifyListeners();
    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      await _apiService.logFood(
        token: token,
        foodId: foodId,
        quantity: quantity,
        mealType: mealType,
        date: date,
      );
      _status = AddFoodStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "Gagal mencatat makanan: $e";
      _status = AddFoodStatus.error;
      notifyListeners();
      return false;
    }
  }
}

