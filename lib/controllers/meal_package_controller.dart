// lib/controllers/meal_package_controller.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Dibutuhkan untuk isSameDay dan CalendarFormat
import '../models/meal_models.dart';
// TODO: Import ApiService dan StorageService jika sudah siap mengambil data asli
// import '../models/api_service.dart';
// import '../models/storage_service.dart';

// Enum untuk status pengambilan data
enum MealPackageStatus { initial, loading, success, failure }

class MealPackageController with ChangeNotifier {
  // TODO: Uncomment ini saat siap mengambil data asli
  // final ApiService _apiService = ApiService();
  // final StorageService _storageService = StorageService();

  // --- State Internal Controller ---
  MealPackageStatus _status = MealPackageStatus.initial;
  String? _errorMessage;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Menyimpan semua jadwal yang di-fetch (Kunci: Tanggal UTC tanpa jam)
  Map<DateTime, Map<String, List<DailySchedule>>> _allSchedules = {};

  // State turunan: jadwal yang akan ditampilkan di UI
  Map<String, List<DailySchedule>> _scheduleForSelectedDay = {};

  // --- Getter untuk UI ---
  MealPackageStatus get status => _status;
  String? get errorMessage => _errorMessage;
  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;
  CalendarFormat get calendarFormat => _calendarFormat;
  Map<String, List<DailySchedule>> get scheduleForSelectedDay =>
      Map.unmodifiable(_scheduleForSelectedDay);

  // --- Constructor ---
  MealPackageController() {
    // Langsung fetch data saat controller dibuat
    fetchSchedules();
  }

  // --- Logika Pengambilan Data ---
  Future<void> fetchSchedules() async {
    _status = MealPackageStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Ganti logika dummy ini dengan panggilan API yang sebenarnya
      // final token = await _storageService.getToken();
      // if (token == null) throw Exception('Token tidak ditemukan, silakan login ulang.');
      // final fetchedSchedules = await _apiService.getMealSchedules(token);
      // _allSchedules = fetchedSchedules; // Simpan data dari API

      // Simulasi pengambilan data dummy
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulasi jeda jaringan
      _allSchedules = _getDummyData(); // Gunakan data dummy

      _status = MealPackageStatus.success;
      // Perbarui jadwal untuk tanggal yang dipilih (saat ini)
      _updateScheduleForSelectedDay();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _status = MealPackageStatus.failure;
    } finally {
      // Selalu beri tahu UI setelah selesai, baik sukses maupun gagal
      notifyListeners();
    }
  }

  // --- Event Handler (Dipanggil oleh View) ---

  /// Dipanggil saat pengguna memilih hari di kalender
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _updateScheduleForSelectedDay(); // Hitung ulang data untuk hari yang dipilih
      notifyListeners(); // Beri tahu UI (kalender & list)
    }
  }

  /// Dipanggil saat pengguna mengganti bulan di kalender
  void onCalendarPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners(); // Beri tahu UI (kalender)
  }

  /// Dipanggil saat format kalender diubah (jika diaktifkan)
  void onFormatChanged(CalendarFormat format) {
    if (_calendarFormat != format) {
      _calendarFormat = format;
      notifyListeners();
    }
  }

  /// Dipanggil saat item jadwal (misal: 'Sarapan') di-tap
  void handleScheduleItemTap(String mealType) {
    // TODO: Implementasi navigasi ke detail jadwal makan atau layar lain
    print("Tapped on meal type: $mealType for day: $_selectedDay");
    // Contoh:
    // _navigationService.navigateTo(Routes.mealDetail, arguments: { 'day': _selectedDay, 'mealType': mealType });
  }

  // --- Logika Internal ---

  /// Memperbarui state `_scheduleForSelectedDay` berdasarkan `_selectedDay`
  void _updateScheduleForSelectedDay() {
    // Normalisasi DateTime ke UTC tanpa jam untuk key lookup
    DateTime dayOnly =
    DateTime.utc(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    // Kembalikan data untuk hari itu atau map kosong jika tidak ada
    _scheduleForSelectedDay = _allSchedules[dayOnly] ?? {};
  }

  /// Data dummy (dipindahkan dari view)
  Map<DateTime, Map<String, List<DailySchedule>>> _getDummyData() {
    return {
      DateTime.utc(DateTime.now().year, DateTime.now().month,
          DateTime.now().day): const {
        'Sarapan': [
          DailySchedule(
              mealName: 'Sarapan',
              time: '07:00am',
              foodName: 'Honey Pancake',
              calories: 450,
              iconAsset: '')
        ],
        'Makan Siang': [
          DailySchedule(
              mealName: 'Makan Siang',
              time: '01:00pm',
              foodName: 'Chicken Steak',
              calories: 600,
              iconAsset: '')
        ],
        'Makan Malam': [
          DailySchedule(
              mealName: 'Makan Malam',
              time: '07:10pm',
              foodName: 'Salad',
              calories: 300,
              iconAsset: '')
        ],
      },
      DateTime.utc(DateTime.now().year, DateTime.now().month,
          DateTime.now().day + 1): const {
        // Besok
        'Sarapan': [
          DailySchedule(
              mealName: 'Sarapan',
              time: '07:30am',
              foodName: 'Oatmeal Buah',
              calories: 350,
              iconAsset: '')
        ],
        'Makan Siang': [
          DailySchedule(
              mealName: 'Makan Siang',
              time: '12:30pm',
              foodName: 'Nasi Goreng Sehat',
              calories: 550,
              iconAsset: '')
        ],
      },
    };
  }
}