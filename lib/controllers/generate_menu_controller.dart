import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/api_service.dart';
import '../models/storage_service.dart';

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

  // --- Logic ---

  // Dipanggil saat radio button diubah (HANYA MENGUBAH STATE)
  void selectPeriod(String? newValue) {
    if (newValue == null || newValue == _selectedPeriod) return;

    _selectedPeriod = newValue;

    // Jika user kembali dari 'rentang_khusus' tanpa memilih tanggal,
    // kita mungkin ingin mereset dateRange (opsional).
    if (_selectedPeriod != 'rentang_khusus') {
      // _dateRange = null; // Opsional: reset jika pindah
    }

    notifyListeners();
  }

  // Fungsi untuk MENGATUR date range (dipanggil DARI SCREEN)
  void setDateRange(DateTimeRange? newRange) {
    if (newRange != null) {
      _dateRange = newRange;
      print('Rentang tanggal di-set: ${_dateRange!.start} - ${_dateRange!.end}');
    } else {
      // Jika user membatalkan, reset pilihan radio kembali ke 'hanya_hari_ini'
      _selectedPeriod = 'hanya_hari_ini';
      _dateRange = null;
      print('Pemilihan rentang tanggal dibatalkan.');
    }
    notifyListeners(); // Update UI
  }


  // Dipanggil saat tombol "Hasilkan Menu" ditekan
  Future<void> generateMenu() async {
    _status = GenerateMenuStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      // 1. Map key frontend ke key backend
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

      // 2. Siapkan body request
      Map<String, dynamic> body = {
        'period': backendPeriod,
      };

      // 3. Tambahkan tanggal jika period-nya 'custom'
      if (backendPeriod == 'custom') {
        if (_dateRange == null) {
          // Beri pesan error spesifik jika tanggal belum dipilih
          throw Exception('Silakan pilih rentang tanggal khusus.');
        }
        // Format tanggal YYYY-MM-DD sesuai standar backend
        body['startDate'] = DateFormat('yyyy-MM-dd').format(_dateRange!.start);
        body['endDate'] = DateFormat('yyyy-MM-dd').format(_dateRange!.end);
      }

      print("Mengirim request generate meal plan: $body"); // Log untuk debug

      // 4. Panggil API
      bool success = await _apiService.generateMealPlan(token, body);

      if (success) {
        _status = GenerateMenuStatus.success;
      } else {
        // Jika API mengembalikan false (misal status 400 atau 500)
        _errorMessage = 'Gagal membuat rencana makan di server.';
        _status = GenerateMenuStatus.failure;
      }
    } catch (e) {
      // Menangkap error (token null, date range null, error jaringan)
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _status = GenerateMenuStatus.failure;
    }
    notifyListeners();
  }
}