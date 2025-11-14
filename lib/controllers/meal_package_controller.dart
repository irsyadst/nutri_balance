import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nutri_balance/models/api_service.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'package:nutri_balance/models/storage_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nutri_balance/utils/notification_service.dart';


class MealPackageController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();

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

      DateTime today = DateTime.now();
      bool isToday = date.year == today.year && date.month == today.month && date.day == today.day;
      bool isFuture = date.isAfter(today);

      if (isToday || isFuture) {

        await _scheduleNotificationsForPlans(plans, date);
      }


      dailySchedule.value = plans;

    } catch (e) {
      errorMessage('Error: ${e.toString()}');
      dailySchedule.value = [];
    } finally {
      isLoading(false);
    }
  }

  Future<void> _scheduleNotificationsForPlans(List<MealPlan> plans, DateTime date) async {
    try {

      debugPrint("Menjadwalkan ${plans.length} notifikasi untuk $date");

      for (final meal in plans) {
        // 1. Parse Waktu ("08:00")
        final timeParts = meal.time.split(':');
        if (timeParts.length != 2) continue;

        final hour = int.tryParse(timeParts[0]);
        final minute = int.tryParse(timeParts[1]);

        if (hour == null || minute == null) continue;

        final scheduledTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        final int notificationId = meal.id.hashCode.abs() % 2147483647;

        final String title = 'Waktunya ${meal.mealType}! 🍽️';
        final String body = 'Jangan lupa untuk ${meal.food.name} (${meal.displayQuantity.toStringAsFixed(0)} ${meal.displayUnit}).';

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

    await _notificationService.cancelAllNotifications();
    await fetchMealPlanForDate(selectedDate.value);
  }
}
