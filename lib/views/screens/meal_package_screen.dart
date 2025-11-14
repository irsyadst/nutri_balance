import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutri_balance/controllers/meal_package_controller.dart';
import 'package:nutri_balance/views/widgets/meal_package/daily_schedule_list.dart';
import 'package:nutri_balance/views/widgets/meal_package/generate_menu_button.dart';
import 'package:nutri_balance/views/widgets/meal_package/meal_calendar.dart';
import 'package:nutri_balance/views/screens/generate_menu_screen.dart';

class MealPackageScreen extends StatelessWidget {
  final MealPackageController controller = Get.put(MealPackageController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paket Makanan'),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          MealCalendar(controller: controller),
          GenerateMenuButton(
            onPressed: () async {
              final result = await Get.to(() => GenerateMenuScreen());

              if (result == true) {
                controller.refreshData();
              }
            },
          ),

          Expanded(
            child: DailyScheduleList(),
          ),
        ],
      ),
    );
  }
}