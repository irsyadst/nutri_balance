// lib/controllers/statistics_controller.dart
import 'dart:math'; // Untuk Random
import 'package:fl_chart/fl_chart.dart'; // Dibutuhkan untuk FlSpot
import 'package:flutter/material.dart';

// Enum untuk status data
enum StatisticsStatus { initial, loading, success, failure }

// Enum untuk kategori detail
enum DetailCategory { calories, weight, macros, water }

class StatisticsController with ChangeNotifier {
  // --- State ---
  StatisticsStatus _status = StatisticsStatus.initial;
  String? _errorMessage;

  // State UI
  String? _selectedDetailCategory;

  // --- Data State (Dummy, ganti dengan fetch API) ---
  double _currentWeight = 68.5;
  double _weightChangePercent = -1.2;
  String _weightPeriod = "7 Hari Terakhir";
  int _caloriesToday = 1850;
  double _calorieChangePercent = -3.5;
  String _macroRatio = "45/30/25";
  double _macroChangePercent = 2.1;
  List<FlSpot> _weightSpots = [];
  Map<String, double> _calorieDataPerMeal = {};
  double _maxCaloriePerMeal = 700;
  Map<String, double> _macroDataPercentage = {};
  // --- Akhir Data State ---

  // --- Getter untuk UI ---
  StatisticsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get selectedDetailCategory => _selectedDetailCategory;

  // Getters untuk Data Ringkasan
  double get currentWeight => _currentWeight;
  double get weightChangePercent => _weightChangePercent;
  String get weightPeriod => _weightPeriod;
  int get caloriesToday => _caloriesToday;
  double get calorieChangePercent => _calorieChangePercent;
  String get macroRatio => _macroRatio;
  double get macroChangePercent => _macroChangePercent;
  List<FlSpot> get weightSpots => _weightSpots; // Diperlukan oleh WeightProgressCard
  Map<String, double> get calorieDataPerMeal => _calorieDataPerMeal;
  double get maxCaloriePerMeal => _maxCaloriePerMeal;
  Map<String, double> get macroDataPercentage => _macroDataPercentage;

  // --- Data Statis ---
  final List<Map<String, dynamic>> detailCategories = const [
    {'title': 'Kalori', 'icon': Icons.local_fire_department_outlined},
    {'title': 'Makronutrien', 'icon': Icons.pie_chart_outline_rounded},
    {'title': 'Asupan Air', 'icon': Icons.water_drop_outlined},
    {'title': 'Berat Badan', 'icon': Icons.monitor_weight_outlined}, // Ditambahkan
  ];

  // --- Constructor ---
  StatisticsController() {
    fetchData(); // Memuat data saat controller diinisialisasi
  }

  // --- Logika Pengambilan Data ---
  Future<void> fetchData() async {
    _status = StatisticsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Ganti dengan logika fetch API
      await Future.delayed(const Duration(milliseconds: 500)); // Simulasi

      // Muat data dummy
      _currentWeight = 68.5;
      _weightChangePercent = -1.2;
      _weightPeriod = "7 Hari Terakhir";
      _caloriesToday = 1850;
      _calorieChangePercent = -3.5;
      _macroRatio = "45/30/25";
      _macroChangePercent = 2.1;
      _weightSpots = [
        FlSpot(0, 70), FlSpot(1, 69.8), FlSpot(2, 69.5), FlSpot(3, 69.6),
        FlSpot(4, 69.2), FlSpot(5, 68.8), FlSpot(6, 68.5),
      ];
      _calorieDataPerMeal = {
        'Sarapan': 450, 'Makan Siang': 600, 'Makan Malam': 550, 'Snack': 250,
      };
      _maxCaloriePerMeal = 700;
      _macroDataPercentage = {
        'Karbohidrat': 45, 'Protein': 30, 'Lemak': 25,
      };

      _status = StatisticsStatus.success;
    } catch (e) {
      _errorMessage = "Gagal memuat data statistik: ${e.toString()}";
      _status = StatisticsStatus.failure;
    } finally {
      notifyListeners();
    }
  }

  // --- Event Handler (Dipanggil oleh View) ---

  /// Dipanggil saat kategori di tab Detail di-tap
  void onDetailCategoryTap(String category) {
    _selectedDetailCategory = category;
    notifyListeners();
  }

  /// Menangani logika tombol kembali (back) di AppBar
  void handleBackButton(TabController tabController, BuildContext context) {
    if (_selectedDetailCategory != null) {
      // 1. Jika di dalam halaman detail, kembali ke daftar detail
      _selectedDetailCategory = null;
      notifyListeners();
    } else if (tabController.index != 0) {
      // 2. Jika di tab Detail (tapi bukan di halaman spesifik), kembali ke tab Ringkasan
      tabController.animateTo(0);
    } else if (Navigator.canPop(context)) {
      // 3. Jika di tab Ringkasan, pop layar (keluar dari Statistik)
      Navigator.pop(context);
    }
  }

  /// Dipanggil oleh listener TabController di view
  void handleTabChange(TabController tabController) {
    // Jika user pindah tab (bukan saat animasi), dan kembali ke tab Ringkasan
    if (!tabController.indexIsChanging &&
        tabController.index == 0 &&
        _selectedDetailCategory != null) {
      // Reset pilihan detail kategori
      _selectedDetailCategory = null;
      notifyListeners();
    }
  }
}