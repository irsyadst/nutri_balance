// lib/controllers/home_controller.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/api_service.dart';
import '../models/storage_service.dart';
import '../models/food_log_model.dart';
import '../views/screens/login_screen.dart'; // Untuk logout

// Enum untuk status data fetching
enum HomeStatus { initial, loading, success, failure }

class HomeController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // --- State ---
  HomeStatus _status = HomeStatus.initial;
  HomeStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _currentUser;
  User? get currentUser => _currentUser;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  List<FoodLogEntry> _todayFoodLogs = [];
  List<FoodLogEntry> get todayFoodLogs => _todayFoodLogs;

  double _consumedCalories = 0;
  double get consumedCalories => _consumedCalories;

  double _consumedProtein = 0;
  double get consumedProtein => _consumedProtein;

  double _consumedCarbs = 0;
  double get consumedCarbs => _consumedCarbs;

  double _consumedFats = 0;
  double get consumedFats => _consumedFats;

  // Data konsumsi per meal type untuk MealTargetGrid
  final Map<String, double> _consumedDataForGrid = {
    'Sarapan': 0.0,
    'Makan Siang': 0.0,
    'Makan Malam': 0.0,
    'Snack': 0.0,
    'Air': 0.0,
    // HAPUS 'Aktivitas': 0.0,
  };
  Map<String, double> get consumedDataForGrid => Map.unmodifiable(_consumedDataForGrid);

  // --- Target ---
  double get targetCalories => _userProfile?.targetCalories?.toDouble() ?? 2000.0;
  double get targetProtein => _userProfile?.targetProteins?.toDouble() ?? 100.0;
  double get targetCarbs => _userProfile?.targetCarbs?.toDouble() ?? 250.0;
  double get targetFats => _userProfile?.targetFats?.toDouble() ?? 60.0;

  // Data target per meal type untuk MealTargetGrid
  Map<String, Map<String, dynamic>> get targetsForGrid {
    final double breakfastTarget = targetCalories * 0.3;
    final double lunchTarget = targetCalories * 0.4;
    final double dinnerTarget = targetCalories * 0.3;
    const double snackTarget = 250.0;

    return {
      'Sarapan': {'icon': Icons.wb_sunny_outlined, 'target': breakfastTarget, 'unit': 'kkal'},
      'Makan Siang': {'icon': Icons.restaurant_menu_outlined, 'target': lunchTarget, 'unit': 'kkal'},
      'Makan Malam': {'icon': Icons.nights_stay_outlined, 'target': dinnerTarget, 'unit': 'kkal'},
      'Snack': {'icon': Icons.bakery_dining_outlined, 'target': snackTarget, 'unit': 'kkal'},
      'Air': {'icon': Icons.water_drop_outlined, 'target': 3.0, 'unit': 'L'},
      // HAPUS 'Aktivitas': {'icon': Icons.fitness_center_outlined, 'target': 500.0, 'unit': 'kkal'},
    };
  }

  // --- Logic ---
  HomeController(User initialUser) {
    _currentUser = initialUser;
    _userProfile = initialUser.profile;
    fetchData();
  }

  Future<void> fetchData() async {
    _status = HomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    String? token = await _storageService.getToken();
    if (token == null) {
      _handleError('Token tidak ditemukan. Silakan login kembali.');
      return;
    }

    try {
      if (_currentUser == null) throw Exception('Data pengguna tidak valid.');
      _userProfile = _currentUser!.profile;
      if (_userProfile == null) throw Exception('Profil pengguna belum lengkap.');

      List<FoodLogEntry> allLogs = await _apiService.getFoodLogHistory(token);
      _calculateTodayConsumption(allLogs);

      _status = HomeStatus.success;
    } catch (e) {
      _handleError('Gagal memuat data: ${e.toString()}');
    } finally {
      notifyListeners();
    }
  }

  void _calculateTodayConsumption(List<FoodLogEntry> allLogs) {
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayFoodLogs = allLogs.where((log) => log.date == todayString).toList();

    _consumedCalories = 0;
    _consumedProtein = 0;
    _consumedCarbs = 0;
    _consumedFats = 0;
    _consumedDataForGrid.updateAll((key, value) => 0.0); // Reset grid data

    for (var log in _todayFoodLogs) {
      double currentCalories = log.food.calories * log.quantity;
      _consumedCalories += currentCalories;
      _consumedProtein += log.food.proteins * log.quantity;
      _consumedCarbs += log.food.carbs * log.quantity;
      _consumedFats += log.food.fats * log.quantity;

      if (_consumedDataForGrid.containsKey(log.mealType)) {
        _consumedDataForGrid[log.mealType] = (_consumedDataForGrid[log.mealType] ?? 0.0) + currentCalories;
      } else {
        _consumedDataForGrid['Snack'] = (_consumedDataForGrid['Snack'] ?? 0.0) + currentCalories;
        print("Warning: Meal type '${log.mealType}' tidak ada di map _consumedDataForGrid, ditambahkan ke Snack.");
      }
    }

    _consumedDataForGrid['Air'] = 1.5; // Contoh
    // HAPUS _consumedDataForGrid['Aktivitas'] = 350; // Contoh

    print("Perhitungan Konsumsi Selesai:");
    print("Kalori: $_consumedCalories");
    print("Protein: $_consumedProtein");
    print("Karbo: $_consumedCarbs");
    print("Lemak: $_consumedFats");
    print("Grid Data: $_consumedDataForGrid");
  }


  void _handleError(String message) {
    _status = HomeStatus.failure;
    _errorMessage = message;
    print("Error di HomeController: $message");
  }

  // Fungsi logout
  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    await _storageService.deleteToken();
    _currentUser = null;
    _userProfile = null;
    _todayFoodLogs = [];
    _status = HomeStatus.initial;
    _setLoading(false);

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
    notifyListeners();
  }

  // Helper loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}