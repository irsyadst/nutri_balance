// lib/controllers/statistics_controller.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:nutri_balance/models/api_service.dart';
import 'package:nutri_balance/models/statistics_summary_model.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

enum StatisticsStatus { initial, loading, success, failure }
enum DetailCategory { calories, macros }
enum StatisticsPeriod { daily, weekly, monthly }

class StatisticsController with ChangeNotifier {
  // --- Dependensi ---
  final ApiService _apiService;
  final String _token;

  // --- State ---
  StatisticsStatus _status = StatisticsStatus.initial;
  String? _errorMessage;
  String? _selectedDetailCategory;

  // --- State Filter (DIPERBARUI) ---
  StatisticsPeriod _selectedPeriod = StatisticsPeriod.daily;
  DateTime _selectedDailyDate = DateTime.now(); // Untuk filter 'Harian'
  DateTime _selectedWeek = DateTime.now();     // Untuk filter 'Mingguan'
  DateTime _selectedMonth = DateTime.now();    // Untuk filter 'Bulanan'
  // --- Akhir State Filter ---

  // --- Data State ---
  int _caloriesToday = 0;
  double _calorieChangePercent = 0.0;
  String _macroRatio = "0/0/0";
  double _macroChangePercent = 0.0;
  Map<String, double> _calorieDataPerMeal = {};
  double _maxCaloriePerMeal = 0;
  Map<String, double> _macroDataPercentage = {};
  // --- Akhir Data State ---

  // --- Getter untuk UI ---
  StatisticsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get selectedDetailCategory => _selectedDetailCategory;
  StatisticsPeriod get selectedPeriod => _selectedPeriod;

  int get caloriesToday => _caloriesToday.round();
  double get calorieChangePercent => _calorieChangePercent;
  String get macroRatio => _macroRatio;
  double get macroChangePercent => _macroChangePercent;
  Map<String, double> get calorieDataPerMeal => _calorieDataPerMeal;
  double get maxCaloriePerMeal => _maxCaloriePerMeal;
  Map<String, double> get macroDataPercentage => _macroDataPercentage;

  final List<Map<String, dynamic>> detailCategories = const [
    {'title': 'Kalori', 'icon': Icons.local_fire_department_outlined},
    {'title': 'Makronutrien', 'icon': Icons.pie_chart_outline_rounded},
  ];

  // --- Constructor ---
  StatisticsController({required ApiService apiService, required String token})
      : _apiService = apiService,
        _token = token {
    fetchData();
  }

// --- Logika Pengambilan Data ---
  Future<void> fetchData() async {
    _status = StatisticsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      DateTime dateToSend;
      switch (_selectedPeriod) {
        case StatisticsPeriod.daily:
          dateToSend = _selectedDailyDate;
          break;
        case StatisticsPeriod.weekly:
          dateToSend = _selectedWeek;
          break;
        case StatisticsPeriod.monthly:
          dateToSend = _selectedMonth;
          break;
      }

      final periodString = _selectedPeriod.name;

      final summary = await _apiService.getStatisticsSummary(_token, dateToSend, periodString);

      _caloriesToday = summary.caloriesToday.round();
      _calorieChangePercent = summary.calorieChangePercent;
      _macroRatio = summary.macroRatio;
      _macroChangePercent = summary.macroChangePercent;
      _calorieDataPerMeal = summary.calorieDataPerMeal;
      _macroDataPercentage = summary.macroDataPercentage;

      if (summary.calorieDataPerMeal.values.isNotEmpty) {
        _maxCaloriePerMeal = summary.calorieDataPerMeal.values.reduce((a, b) => a > b ? a : b);
        _maxCaloriePerMeal = _maxCaloriePerMeal * 1.1;
      } else {
        _maxCaloriePerMeal = 100;
      }

      _status = StatisticsStatus.success;
    } catch (e) {
      _errorMessage = "Gagal memuat data statistik: ${e.toString()}";
      _status = StatisticsStatus.failure;
    } finally {
      notifyListeners();
    }
  }

  /// Dipanggil oleh SegmentedButton di view
  void changePeriod(StatisticsPeriod newPeriod) {
    if (newPeriod == _selectedPeriod) return;

    _selectedPeriod = newPeriod;

    _selectedDailyDate = DateTime.now();
    _selectedWeek = DateTime.now();
    _selectedMonth = DateTime.now();

    notifyListeners();
    fetchData();
  }

  /// Dipanggil oleh tombol kalender (mode 'daily')
  Future<void> changeDailyDate(BuildContext context) async {
    if (_selectedPeriod != StatisticsPeriod.daily) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDailyDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null && picked != _selectedDailyDate) {
      _selectedDailyDate = picked;
      notifyListeners();
      fetchData();
    }
  }
  /// Dipanggil oleh tombol kalender (mode 'weekly')
  Future<void> changeWeek(BuildContext context) async {
    if (_selectedPeriod != StatisticsPeriod.weekly) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedWeek,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null && picked != _selectedWeek) {
      _selectedWeek = picked;
      notifyListeners();
      fetchData();
    }
  }
  /// Dipanggil oleh tombol kalender (mode 'monthly')
  Future<void> changeMonth(BuildContext context) async {
    if (_selectedPeriod != StatisticsPeriod.monthly) return;

    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null &&
        (picked.month != _selectedMonth.month || picked.year != _selectedMonth.year)) {
      _selectedMonth = picked;
      notifyListeners();
      fetchData();
    }
  }

  /// Formatter untuk judul tanggal
  String get selectedDateFormatted {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_selectedPeriod) {
      case StatisticsPeriod.weekly:
        final refWeekDay = DateTime(_selectedWeek.year, _selectedWeek.month, _selectedWeek.day);
        final startOfWeek = refWeekDay.subtract(Duration(days: refWeekDay.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        final startOfCurrentWeek = today.subtract(Duration(days: today.weekday - 1));
        if (startOfWeek.isAtSameMomentAs(startOfCurrentWeek)) {
          return 'Minggu Ini';
        }

        if(startOfWeek.year == endOfWeek.year) {
          return '${DateFormat('d MMM', 'id_ID').format(startOfWeek)} - ${DateFormat('d MMM yyyy', 'id_ID').format(endOfWeek)}';
        } else {
          return '${DateFormat('d MMM yyyy', 'id_ID').format(startOfWeek)} - ${DateFormat('d MMM yyyy', 'id_ID').format(endOfWeek)}';
        }

      case StatisticsPeriod.monthly:
        final refMonth = DateTime(_selectedMonth.year, _selectedMonth.month);

        if (refMonth.year == today.year && refMonth.month == today.month) {
          return 'Bulan Ini';
        }

        return DateFormat('MMMM yyyy', 'id_ID').format(_selectedMonth);

      case StatisticsPeriod.daily:
      default:
        final selectedDay = DateTime(_selectedDailyDate.year, _selectedDailyDate.month, _selectedDailyDate.day);

        if (selectedDay.isAtSameMomentAs(today)) {
          return 'Hari Ini';
        }

        final yesterday = today.subtract(const Duration(days: 1));
        if (selectedDay.isAtSameMomentAs(yesterday)) {
          return 'Kemarin';
        }

        return DateFormat('d MMM yyyy', 'id_ID').format(_selectedDailyDate);
    }
  }

  // --- Event Handler (Sisa) ---
  void onDetailCategoryTap(String category) {
    _selectedDetailCategory = category;
    notifyListeners();
  }

  void handleBackButton(TabController tabController, BuildContext context) {
    if (_selectedDetailCategory != null) {
      _selectedDetailCategory = null;
      notifyListeners();
    } else if (tabController.index != 0) {
      tabController.animateTo(0);
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void handleTabChange(TabController tabController) {
    if (!tabController.indexIsChanging &&
        tabController.index == 0 &&
        _selectedDetailCategory != null) {
      _selectedDetailCategory = null;
      notifyListeners();
    }
  }
}