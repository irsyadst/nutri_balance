import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_balance/models/api_service.dart';
import 'package:nutri_balance/models/food_log_model.dart';
import 'package:nutri_balance/models/storage_service.dart';

enum FoodLogStatus { loading, success, error }

class FoodLogController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final String _token;

  // State
  FoodLogStatus _status = FoodLogStatus.loading;
  FoodLogStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Data
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  List<FoodLogEntry> _allLogs = []; // Menyimpan semua log
  List<FoodLogEntry> _logsForSelectedDate = []; // Log yang difilter
  List<FoodLogEntry> get logsForSelectedDate => _logsForSelectedDate;

  // Formatter untuk membandingkan tanggal
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

  // Constructor
  FoodLogController({required String token}) : _token = token {
    fetchFullHistory();
  }

  // Ambil semua data sekali, lalu filter
  Future<void> fetchFullHistory() async {
    _status = FoodLogStatus.loading;
    notifyListeners();

    try {
      _allLogs = await _apiService.getFoodLogHistory(_token);
      // Langsung filter untuk hari ini
      filterLogsByDate(_selectedDate);
      _status = FoodLogStatus.success;
    } catch (e) {
      _errorMessage = "Gagal memuat riwayat: $e";
      _status = FoodLogStatus.error;
    } finally {
      notifyListeners();
    }
  }

  // Fungsi untuk memfilter log berdasarkan tanggal yang dipilih
  void filterLogsByDate(DateTime date) {
    _selectedDate = date;
    final dateString = _dateFormatter.format(date);

    _logsForSelectedDate = _allLogs.where((log) {
      // Backend mengembalikan tanggal sebagai string 'yyyy-MM-dd'
      return log.date == dateString;
    }).toList();

    notifyListeners();
  }

  // Fungsi untuk menampilkan date picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)), // Hanya sampai besok
    );
    if (picked != null && picked != _selectedDate) {
      filterLogsByDate(picked);
    }
  }

  // Getter untuk format judul AppBar
  String get selectedDateFormatted {
    final today = _dateFormatter.format(DateTime.now());
    final selectedDay = _dateFormatter.format(_selectedDate);

    if (selectedDay == today) {
      return 'Hari Ini';
    }
    // Format: 3 Nov 2025
    return DateFormat('d MMM yyyy', 'id_ID').format(_selectedDate);
  }
}
