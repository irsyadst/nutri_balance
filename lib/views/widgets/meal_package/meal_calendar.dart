import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutri_balance/controllers/meal_package_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class MealCalendar extends StatelessWidget {
  final MealPackageController controller;

  const MealCalendar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bungkus dengan Obx agar UI otomatis update
    return Obx(() {
      return TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),

        // Gunakan .value dari controller
        focusedDay: controller.focusedDate.value,
        selectedDayPredicate: (day) {
          return isSameDay(controller.selectedDate.value, day);
        },
        calendarFormat: controller.calendarFormat.value,

        // Panggil fungsi di controller
        onDaySelected: controller.onDateSelected,
        onFormatChanged: controller.onFormatChanged,
        onPageChanged: controller.onPageChanged,

        // Styling
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      );
    });
  }
}