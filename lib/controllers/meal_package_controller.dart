import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nutri_balance/models/api_service.dart';
import 'package:nutri_balance/models/meal_models.dart';
import 'package:nutri_balance/models/storage_service.dart';
import 'package:table_calendar/table_calendar.dart'; // <-- Pastikan ini ada

class MealPackageController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

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

      dailySchedule.value = plans;

    } catch (e) {
      errorMessage('Error: ${e.toString()}');
      dailySchedule.value = [];
    } finally {
      isLoading(false);
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

  void refreshData() {
    fetchMealPlanForDate(selectedDate.value);
  }
}