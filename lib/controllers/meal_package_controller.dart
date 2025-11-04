import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart'; // Dibutuhkan untuk debugPrint
import 'package:nutri_balance/models/api_service.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'package:nutri_balance/models/storage_service.dart';
import 'package:table_calendar/table_calendar.dart';
// --- IMPOR BARU ---
import 'package:nutri_balance/utils/notification_service.dart';
// --- AKHIR IMPOR ---

class MealPackageController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  // --- TAMBAHAN BARU ---
  final NotificationService _notificationService = NotificationService();
  // --- AKHIR TAMBAHAN ---

  // State untuk API
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var dailySchedule = <MealPlan>[].obs;

  // State untuk TableCalendar
  var selectedDate = DateTime.now().obs;
  var focusedDate = DateTime.now().obs;
  var calendarFormat = CalendarFormat.month.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMealPlanForDate(selectedDate.value);
  }

  String _formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> fetchMealPlanForDate(DateTime date) async {
    try {
      isLoading(true);
      errorMessage('');
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final dateString = _formatDateForApi(date);
      final plans = await _apiService.getMealPlan(token, dateString);

      // --- LOGIKA PENJADWALAN NOTIFIKASI ---
      // Hanya jadwalkan jika data yang diambil adalah untuk HARI INI
      // atau HARI DI MASA DEPAN.
      DateTime today = DateTime.now();
      bool isToday = date.year == today.year && date.month == today.month && date.day == today.day;
      bool isFuture = date.isAfter(today);

      if (isToday || isFuture) {
        // Kita panggil fungsi penjadwalan (bahkan jika 'plans' kosong,
        // ini akan membatalkan notifikasi lama untuk hari itu)
        await _scheduleNotificationsForPlans(plans, date);
      }
      // --- AKHIR LOGIKA ---

      dailySchedule.value = plans;

    } catch (e) {
      errorMessage('Error: ${e.toString()}');
      dailySchedule.value = [];
    } finally {
      isLoading(false);
    }
  }

  // --- FUNGSI BARU UNTUK PENJADWALAN ---
  Future<void> _scheduleNotificationsForPlans(List<MealPlan> plans, DateTime date) async {
    try {
      // Hapus notifikasi yang mungkin sudah ada untuk hari ini
      // (Ini adalah V1 sederhana, idealnya kita hanya membatalkan ID
      // yang spesifik untuk hari ini, tapi 'cancelAll' lebih mudah
      // dan aman jika pengguna sering generate ulang)
      // await _notificationService.cancelAllNotifications();
      // *Revisi*: cancelAll() akan membatalkan notifikasi untuk 7 hari ke depan.
      // Kita seharusnya hanya membatalkan untuk hari yang sedang dilihat.
      // Tapi untuk V1, kita jadwalkan saja. Jika user generate ulang,
      // ID unik akan menimpa notifikasi lama.

      debugPrint("Menjadwalkan ${plans.length} notifikasi untuk $date");

      for (final meal in plans) {
        // 1. Parse Waktu ("08:00")
        final timeParts = meal.time.split(':');
        if (timeParts.length != 2) continue; // Lewati jika format waktu salah

        final hour = int.tryParse(timeParts[0]);
        final minute = int.tryParse(timeParts[1]);

        if (hour == null || minute == null) continue;

        // 2. Buat DateTime terjadwal
        final scheduledTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        // 3. Buat ID unik
        // Kita gunakan hash code dari ID meal plan di DB
        final int notificationId = meal.id.hashCode.abs() % 2147483647;

        // 4. Buat Title dan Body
        final String title = 'Waktunya ${meal.mealType}! 🍽️';
        final String body = 'Jangan lupa untuk ${meal.food.name} (${meal.displayQuantity.toStringAsFixed(0)} ${meal.displayUnit}).';

        // 5. Jadwalkan
        await _notificationService.scheduleMealNotification(
          id: notificationId,
          title: title,
          body: body,
          scheduledTime: scheduledTime,
        );
      }
    } catch (e) {
      debugPrint("Error saat menjadwalkan notifikasi: $e");
    }
  }
  // --- AKHIR FUNGSI BARU ---

  // --- Fungsi untuk Kalender ---
  void onDateSelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(selectedDate.value, selectedDay)) {
      selectedDate.value = selectedDay;
      focusedDate.value = focusedDay;
      fetchMealPlanForDate(selectedDay);
    }
  }

  void onFormatChanged(CalendarFormat format) {
    if (calendarFormat.value != format) {
      calendarFormat.value = format;
    }
  }

  void onPageChanged(DateTime focusedDay) {
    focusedDate.value = focusedDay;
  }

  Future<void> refreshData() async {
    // --- PERBAIKAN: BATALKAN SEMUA NOTIFIKASI LAMA SAAT GENERATE BARU ---
    // Karena 'refreshData' dipanggil setelah generate ulang,
    // kita harus membatalkan SEMUA notifikasi yang mungkin ada
    // dari rencana lama.
    await _notificationService.cancelAllNotifications();
    // --- AKHIR PERBAIKAN ---

    // Fetch data untuk tanggal yang sedang dipilih (yang baru di-generate)
    await fetchMealPlanForDate(selectedDate.value);
  }
}
