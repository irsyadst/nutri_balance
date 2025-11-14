import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/api_service.dart';
import '../models/storage_service.dart';
import 'package:get/get.dart';

// Enum untuk status proses generate
enum GenerateMenuStatus { initial, loading, success, failure }

class GenerateMenuController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // --- State ---
  GenerateMenuStatus _status = GenerateMenuStatus.initial;
  GenerateMenuStatus get status => _status;

  String _selectedPeriod = 'hanya_hari_ini';
  String get selectedPeriod => _selectedPeriod;

  DateTimeRange? _dateRange;
  DateTimeRange? get dateRange => _dateRange;

  // Helper getter untuk menampilkan teks date range di UI
  String get dateRangeText {
    if (_dateRange == null) return 'Pilih tanggal...';
    // Format tanggal (contoh: 25 Okt - 31 Okt)
    final start = DateFormat('d MMM', 'id_ID').format(_dateRange!.start);
    final end = DateFormat('d MMM', 'id_ID').format(_dateRange!.end);
    return '$start - $end';
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void selectPeriod(String? newValue) {
    if (newValue == null || newValue == _selectedPeriod) return;

    _selectedPeriod = newValue;

    if (_selectedPeriod != 'rentang_khusus') {
    }

    notifyListeners();
  }

  // Fungsi untuk MENGATUR date range (dipanggil DARI SCREEN)
  void setDateRange(DateTimeRange? newRange) {
    if (newRange != null) {
      _dateRange = newRange;
      print('Rentang tanggal di-set: ${_dateRange!.start} - ${_dateRange!.end}');
    } else {
      _selectedPeriod = 'hanya_hari_ini';
      _dateRange = null;
      print('Pemilihan rentang tanggal dibatalkan.');
    }
    notifyListeners(); // Update UI
  }


  Future<void> generateMenu() async {
    _status = GenerateMenuStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      String backendPeriod;
      switch (_selectedPeriod) {
        case '3_hari':
          backendPeriod = '3_days';
          break;
        case '1_minggu':
          backendPeriod = '1_week';
          break;
        case 'rentang_khusus':
          backendPeriod = 'custom';
          break;
        case 'hanya_hari_ini':
        default:
          backendPeriod = 'today';
      }

      Map<String, dynamic> body = {
        'period': backendPeriod,
      };

      if (backendPeriod == 'custom') {
        if (_dateRange == null) {
          throw Exception('Silakan pilih rentang tanggal khusus.');
        }
        body['startDate'] = DateFormat('yyyy-MM-dd').format(_dateRange!.start);
        body['endDate'] = DateFormat('yyyy-MM-dd').format(_dateRange!.end);
      }

      print("Mengirim request generate meal plan: $body");

      bool success = await _apiService.generateMealPlan(token, body);

      if (success) {
        _status = GenerateMenuStatus.success;
        Get.back(result: true);
        // -------------------------
      } else {
        _errorMessage = 'Gagal membuat rencana makan di server.';
        _status = GenerateMenuStatus.failure;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _status = GenerateMenuStatus.failure;
      notifyListeners();
    }
}
}