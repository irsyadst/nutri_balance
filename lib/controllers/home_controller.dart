import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// --- TAMBAHAN IMPOR ---
import 'package:shared_preferences/shared_preferences.dart';
// --- AKHIR TAMBAHAN ---
import '../models/api_service.dart';
import '../models/storage_service.dart';
import '../views/screens/login_screen.dart';
import '../models/user_model.dart';
import '../models/food_log_model.dart';
import '../views/screens/food_log_screen.dart';

// --- DEFINISI ENUM (Perbaikan) ---
enum HomeStatus { initial, loading, success, failure }
// --- AKHIR DEFINISI ENUM ---

class HomeController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // --- TAMBAHAN KUNCI LOKAL ---
  static const String _waterKey = 'consumed_water';
  static const String _lastResetKey = 'last_water_reset';
  // --- AKHIR TAMBAHAN ---

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

  String? _token;

  double _consumedCalories = 0;
  double get consumedCalories => _consumedCalories;

  double _consumedProtein = 0;
  double _consumedCarbs = 0;
  double _consumedFats = 0;

  // --- TAMBAHAN STATE AIR ---
  double _consumedWater = 0.0;
  double get consumedWater => _consumedWater;
  // --- AKHIR TAMBAHAN ---

  double get consumedProtein => _consumedProtein;
  double get consumedCarbs => _consumedCarbs;
  double get consumedFats => _consumedFats;

  final Map<String, double> _consumedDataForGrid = {
    'Sarapan': 0.0,
    'Makan Siang': 0.0,
    'Makan Malam': 0.0,
    'Snack': 0.0,
    'Air': 0.0,
  };
  Map<String, double> get consumedDataForGrid => Map.unmodifiable(_consumedDataForGrid);

  // --- Target ---
  double get targetCalories => _userProfile?.targetCalories?.toDouble() ?? 2000.0;
  double get targetProtein => _userProfile?.targetProteins?.toDouble() ?? 100.0;
  double get targetCarbs => _userProfile?.targetCarbs?.toDouble() ?? 250.0;
  double get targetFats => _userProfile?.targetFats?.toDouble() ?? 60.0;

  Map<String, Map<String, dynamic>> get targetsForGrid {
    // Logika alokasi target Anda yang sudah benar
    const double snackTarget = 250.0;
    final double mainMealCalories = (targetCalories - snackTarget) > 0 ? (targetCalories - snackTarget) : 0;
    final double breakfastTarget = mainMealCalories * 0.3;
    final double lunchTarget = mainMealCalories * 0.4;
    final double dinnerTarget = mainMealCalories * 0.3;

    return {
      'Sarapan': {'icon': Icons.wb_sunny_outlined, 'target': breakfastTarget, 'unit': 'kkal'},
      'Makan Siang': {'icon': Icons.restaurant_menu_outlined, 'target': lunchTarget, 'unit': 'kkal'},
      'Makan Malam': {'icon': Icons.nights_stay_outlined, 'target': dinnerTarget, 'unit': 'kkal'},
      'Snack': {'icon': Icons.bakery_dining_outlined, 'target': snackTarget, 'unit': 'kkal'},
      'Air': {'icon': Icons.water_drop_outlined, 'target': 3.0, 'unit': 'L'},
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

    _token = await _storageService.getToken();
    if (_token == null) {
      _handleError('Token tidak ditemukan. Silakan login kembali.');
      return;
    }

    try {
      // --- TAMBAHAN: Muat data air ---
      await _loadWaterIntake();
      // --- AKHIR TAMBAHAN ---

      if (_currentUser == null) throw Exception('Data pengguna tidak valid.');
      _userProfile = _currentUser!.profile;
      if (_userProfile == null) throw Exception('Profil pengguna belum lengkap.');

      List<FoodLogEntry> allLogs = await _apiService.getFoodLogHistory(_token!);
      _calculateTodayConsumption(allLogs);

      _status = HomeStatus.success;
    } catch (e) {
      _handleError('Gagal memuat data: ${e.toString()}');
    } finally {
      notifyListeners();
    }
  }

  // --- TAMBAHAN: FUNGSI-FUNGSI AIR ---

  /// Memuat data air dari SharedPreferences dan me-reset jika beda hari
  Future<void> _loadWaterIntake() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final lastResetDate = prefs.getString(_lastResetKey);

      if (lastResetDate != todayString) {
        // Jika hari telah berganti, reset data air
        await _resetWaterIntake(prefs, todayString);
      } else {
        // Jika masih hari yang sama, muat data
        _consumedWater = prefs.getDouble(_waterKey) ?? 0.0;
      }
    } catch (e) {
      debugPrint("Gagal memuat data air: $e");
      _consumedWater = 0.0; // Set default jika error
    }
    // (notifyListeners() tidak perlu di sini, akan dipanggil oleh fetchData)
  }

  /// Me-reset data air di SharedPreferences
  Future<void> _resetWaterIntake(SharedPreferences prefs, String todayDate) async {
    _consumedWater = 0.0;
    await prefs.setDouble(_waterKey, 0.0);
    await prefs.setString(_lastResetKey, todayDate);
  }

  /// Fungsi publik untuk menambah air (dipanggil oleh UI)
  /// amountInLiters: jumlah air yang ditambahkan (misal: 0.25 untuk 250ml)
  Future<void> addWater(double amountInLiters) async {
    try {
      _consumedWater += amountInLiters;

      // Update di grid data
      _consumedDataForGrid['Air'] = _consumedWater;

      // Simpan ke lokal
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_waterKey, _consumedWater);

      notifyListeners(); // Perbarui UI
    } catch (e) {
      debugPrint("Gagal menambah air: $e");
    }
  }

  /// Fungsi publik untuk mengurangi air (dipanggil oleh UI)
  Future<void> removeWater(double amountInLiters) async {
    try {
      // Pastikan tidak negatif
      _consumedWater -= amountInLiters;
      if (_consumedWater < 0) {
        _consumedWater = 0.0;
      }

      // Update di grid data
      _consumedDataForGrid['Air'] = _consumedWater;

      // Simpan ke lokal
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_waterKey, _consumedWater);

      notifyListeners(); // Perbarui UI
    } catch (e) {
      debugPrint("Gagal mengurangi air: $e");
    }
  }

  // --- AKHIR TAMBAHAN FUNGSI AIR ---


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

    // --- PERBAIKAN: Ganti data air 'Contoh' dengan data asli ---
    _consumedDataForGrid['Air'] = _consumedWater;
    // --- AKHIR PERBAIKAN ---

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

  // Ganti nama fungsi agar konsisten
  void navigateToFoodLog(BuildContext context) {
    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesi tidak valid, silakan login ulang.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        // Kirim token ke FoodLogScreen
        builder: (context) => FoodLogScreen(token: _token!),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    await _storageService.deleteToken();
    _currentUser = null;
    _userProfile = null;
    _todayFoodLogs = [];
    _status = HomeStatus.initial;
    _token = null;
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



