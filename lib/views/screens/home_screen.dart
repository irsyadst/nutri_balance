// lib/views/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../../models/user_model.dart';
import '../../models/api_service.dart'; // Import ApiService
import '../../models/storage_service.dart'; // Import StorageService
import '../../models/food_log_model.dart'; // Import FoodLogEntry
// Import widget
import '../widgets/home/home_header.dart';
import '../widgets/home/calorie_macro_card.dart';
import '../widgets/home/target_check_button.dart';
import '../widgets/home/meal_target_grid.dart';
import '../widgets/home/add_food_button.dart';
// Import screen lain jika diperlukan untuk refresh/navigasi error
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  // Terima user awal saat navigasi
  final User initialUser;
  const HomeScreen({super.key, required this.initialUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State
  bool _isLoading = true; // Status loading awal
  User? _currentUser; // Data user saat ini (bisa null awalnya)
  UserProfile? _userProfile; // Profil user (untuk target)
  List<FoodLogEntry> _todayFoodLogs = []; // Log makanan hari ini
  // State untuk data konsumsi hari ini
  double _consumedCalories = 0;
  double _consumedProtein = 0;
  double _consumedCarbs = 0;
  double _consumedFats = 0;
  // TODO: Tambahkan state untuk air dan aktivitas jika diperlukan

  // Instance service (idealnya via dependency injection)
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  Map<String, double> _consumedDataForGrid = {};
  @override
  void initState() {
    super.initState();
    _currentUser = widget.initialUser; // Set user awal
    _userProfile = _currentUser?.profile;
    _fetchData(); // Panggil fungsi untuk mengambil data
  }

  // Fungsi untuk mengambil data dari API
  Future<void> _fetchData() async {
    setState(() => _isLoading = true); // Mulai loading

    String? token = await _storageService.getToken();
    if (token == null) {
      _handleErrorAndLogout('Sesi tidak valid, silakan login kembali.');
      return;
    }

    // Ambil profil terbaru (jika perlu) ATAU gunakan data awal
    // User? fetchedUser = await _apiService.getProfile(token);
    // if (!mounted) return;
    // if (fetchedUser == null) {
    //   _handleErrorAndLogout('Gagal mengambil profil, silakan login kembali.');
    //   return;
    // }
    // setState(() {
    //   _currentUser = fetchedUser;
    //   _userProfile = fetchedUser.profile;
    // });
    // ---> ATAU, jika yakin data awal cukup:
    if (_currentUser == null) {
      _handleErrorAndLogout('Data pengguna tidak ditemukan.');
      return;
    }
    // Update profile just in case it was null initially but passed from login/signup
    _userProfile = _currentUser!.profile;

    // Ambil riwayat log makanan
    List<FoodLogEntry> allLogs = await _apiService.getFoodLogHistory(token);
    if (!mounted) return;

    // Hitung total konsumsi DAN konsumsi per meal type
    _calculateTodayConsumption(allLogs);

    setState(() => _isLoading = false); // Selesai loading
  }

  void _calculateTodayConsumption(List<FoodLogEntry> allLogs) {
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayFoodLogs = allLogs.where((log) => log.date == todayString).toList();

    _consumedCalories = 0;
    _consumedProtein = 0;
    _consumedCarbs = 0;
    _consumedFats = 0;
    // Reset data grid juga
    _consumedDataForGrid = {
      'Sarapan': 0.0,
      'Makan Siang': 0.0, // Sesuaikan key jika berbeda
      'Makan Malam': 0.0,
      'Makanan Ringan': 0.0, // Atau 'Snack'
      'Air': 0.0, // Masih dummy/placeholder
      'Aktivitas': 0.0, // Masih dummy/placeholder
    };

    for (var log in _todayFoodLogs) {
      double currentCalories = log.food.calories * log.quantity;
      _consumedCalories += currentCalories;
      _consumedProtein += log.food.proteins * log.quantity;
      _consumedCarbs += log.food.carbs * log.quantity;
      _consumedFats += log.food.fats * log.quantity;

      // Tambahkan kalori ke meal type yang sesuai di map grid
      if (_consumedDataForGrid.containsKey(log.mealType)) {
        _consumedDataForGrid[log.mealType] =
            _consumedDataForGrid[log.mealType]! + currentCalories;
      } else {
        // Jika mealType tidak ada di map (misal 'Snack'), tambahkan ke 'Makanan Ringan' atau default
        _consumedDataForGrid['Makanan Ringan'] =
            (_consumedDataForGrid['Makanan Ringan'] ?? 0.0) + currentCalories;
      }
    }
    // Tambahkan data dummy untuk Air dan Aktivitas jika belum ada dari sumber lain
    _consumedDataForGrid['Air'] = 1.5; // Contoh
    _consumedDataForGrid['Aktivitas'] = 350; // Contoh
  }

  // Fungsi untuk handle error dan logout
  void _handleErrorAndLogout(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    _storageService.deleteToken(); // Hapus token
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil target dari profil (dengan nilai default jika null)
    final targetCalories = _userProfile?.targetCalories?.toDouble() ?? 2000.0;
    final targetProtein = _userProfile?.targetProteins?.toDouble() ?? 100.0;
    final targetCarbs = _userProfile?.targetCarbs?.toDouble() ?? 250.0;
    final targetFats = _userProfile?.targetFats?.toDouble() ?? 60.0;
    final Map<String, Map<String, dynamic>> targetsForGrid = {
      // Ambil target kalori per meal jika ada di backend, jika tidak, bagi rata (contoh)
      'Sarapan': {
        'icon': Icons.wb_sunny_outlined,
        'target': targetCalories * 0.3,
        'unit': 'kkal'
      },
      'Makan Siang': {
        'icon': Icons.restaurant_menu_outlined,
        'target': targetCalories * 0.4,
        'unit': 'kkal'
      },
      'Makan Malam': {
        'icon': Icons.nights_stay_outlined,
        'target': targetCalories * 0.3,
        'unit': 'kkal'
      },
      // Target snack bisa dihitung dari sisa kalori atau nilai tetap
      'Makanan Ringan': {
        'icon': Icons.bakery_dining_outlined,
        'target': 250.0,
        'unit': 'kkal'
      }, // Contoh target tetap
      'Air': {
        'icon': Icons.water_drop_outlined,
        'target': 3.0,
        'unit': 'L'
      }, // Target air (dummy)
      'Aktivitas': {
        'icon': Icons.fitness_center_outlined,
        'target': 500.0,
        'unit': 'kkal'
      }, // Target aktivitas (dummy)
    };

    return Scaffold(
      backgroundColor: Colors.grey[50], // Background sedikit abu
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Tampilkan loading
          : RefreshIndicator(
              // Tambahkan RefreshIndicator
              onRefresh: _fetchData, // Panggil _fetchData saat refresh
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Selalu bisa di-scroll untuk refresh
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gunakan HomeHeader widget
                    HomeHeader(userName: _currentUser?.name ?? 'Pengguna'),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          // Gunakan CalorieMacroCard dengan data dari state
                          CalorieMacroCard(
                            caloriesEaten: _consumedCalories,
                            caloriesGoal: targetCalories,
                            proteinEaten: _consumedProtein.round(),
                            proteinGoal: targetProtein.round(),
                            fatsEaten: _consumedFats.round(),
                            fatsGoal: targetFats.round(),
                            carbsEaten: _consumedCarbs.round(),
                            carbsGoal: targetCarbs.round(),
                          ),
                          const SizedBox(height: 25), // Tambah jarak

                          // Gunakan TargetCheckButton widget
                          const TargetCheckButton(),
                          const SizedBox(height: 15), // Tambah jarak

                          // Gunakan MealTargetGrid widget
                          // TODO: Perlu memodifikasi MealTargetGrid untuk menerima data konsumsi per meal
                          // Untuk sementara, biarkan menggunakan data internalnya
                          MealTargetGrid(
                            targets: targetsForGrid,
                            consumedData:
                                _consumedDataForGrid, // Kirim data konsumsi
                          ),
                          const SizedBox(height: 25), // Tambah jarak

                          // Gunakan AddFoodButton widget
                          const AddFoodButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40), // Bottom padding
                  ],
                ),
              ),
            ),
    );
  }
}
