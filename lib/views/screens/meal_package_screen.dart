import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutri_balance/controllers/meal_package_controller.dart';
import 'package:nutri_balance/views/widgets/meal_package/daily_schedule_list.dart';
import 'package:nutri_balance/views/widgets/meal_package/generate_menu_button.dart';
import 'package:nutri_balance/views/widgets/meal_package/meal_calendar.dart';
import 'package:nutri_balance/views/screens/generate_menu_screen.dart';

// UBAH JADI STATELESS WIDGET
class MealPackageScreen extends StatelessWidget {
  // Inisialisasi controller menggunakan Get.put()
  final MealPackageController controller = Get.put(MealPackageController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paket Makanan'),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          // 1. Kalender (mengirim controller)
          MealCalendar(controller: controller),

          // 2. Tombol Generate (menggunakan controller)
          GenerateMenuButton(
            onPressed: () async {
              // Navigasi ke halaman generate
              final result = await Get.to(() => GenerateMenuScreen());

              // Jika halaman generate mengembalikan 'true' (artinya sukses)
              if (result == true) {
                // Refresh data di layar ini
                controller.refreshData();
              }
            },
          ),

          // 3. Expanded untuk list
          Expanded(
            // DailyScheduleList sekarang mengambil controller via Get.find()
            child: DailyScheduleList(),
          ),
        ],
      ),
    );
  }
}