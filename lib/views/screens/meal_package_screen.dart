import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../models/meal_models.dart';
// Import widget baru
import '../widgets/meal_package/meal_calendar.dart';
import '../widgets/meal_package/daily_schedule_list.dart';
import '../widgets/meal_package/generate_menu_button.dart';
// Import screen tujuan (jika belum)

class MealPackageScreen extends StatefulWidget {
  const MealPackageScreen({super.key});

  @override
  State<MealPackageScreen> createState() => _MealPackageScreenState();
}

class _MealPackageScreenState extends State<MealPackageScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // --- Data Dummy (Pindahkan ke Controller/State Management nantinya) ---
  final Map<DateTime, Map<String, List<DailySchedule>>> _dailySchedules = {
    // Contoh data untuk beberapa hari (gunakan DateTime tanpa informasi jam)
    DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day): const {
      'Sarapan': [DailySchedule(mealName: 'Sarapan', time: '07:00am', foodName: 'Honey Pancake', calories: 450, iconAsset: '')],
      'Makan Siang': [DailySchedule(mealName: 'Makan Siang', time: '01:00pm', foodName: 'Chicken Steak', calories: 600, iconAsset: '')],
      'Makan Malam': [DailySchedule(mealName: 'Makan Malam', time: '07:10pm', foodName: 'Salad', calories: 300, iconAsset: '')],
    },
    DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1): const { // Besok
      'Sarapan': [DailySchedule(mealName: 'Sarapan', time: '07:30am', foodName: 'Oatmeal Buah', calories: 350, iconAsset: '')],
      'Makan Siang': [DailySchedule(mealName: 'Makan Siang', time: '12:30pm', foodName: 'Nasi Goreng Sehat', calories: 550, iconAsset: '')],
    },
    // Tambahkan data hari lain jika perlu
  };

  // Fungsi untuk mendapatkan jadwal berdasarkan hari yang dipilih
  Map<String, List<DailySchedule>> _getScheduleForDay(DateTime day) {
    // Normalisasi DateTime ke UTC tanpa jam untuk key lookup
    DateTime dayOnly = DateTime.utc(day.year, day.month, day.day);
    // Kembalikan data untuk hari itu atau map kosong jika tidak ada
    return _dailySchedules[dayOnly] ?? {};
  }
  // --- Akhir Data Dummy ---


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Hanya update state jika hari yang dipilih berbeda
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay; // Update focusedDay juga
        // Tidak perlu memanggil _getScheduleForDay di sini karena sudah dipanggil di build
      });
    }
  }

  // Callback untuk onPageChanged di kalender
  void _onCalendarPageChanged(DateTime focusedDay) {
    setState(() { // Perlu setState agar UI kalender update bulannya
      _focusedDay = focusedDay;
    });
  }

  // Callback saat item jadwal di tap
  void _handleScheduleItemTap(String mealType) {
    // TODO: Implementasi navigasi ke detail jadwal makan atau layar lain
    print("Tapped on meal type: $mealType for day: $_selectedDay");
    // Contoh: Navigator.push(context, MaterialPageRoute(builder: (context) => MealDetailScreen(day: _selectedDay, mealType: mealType)));
  }

  @override
  Widget build(BuildContext context) {
    // Ambil jadwal untuk hari yang sedang dipilih
    final scheduleForSelectedDay = _getScheduleForDay(_selectedDay);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Jadwal Makan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18)), // Rename title
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gunakan MealCalendar widget
            MealCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              calendarFormat: _calendarFormat,
              onDaySelected: _onDaySelected,
              onPageChanged: _onCalendarPageChanged, // Tambahkan callback ini
              // onFormatChanged: (format) => setState(() => _calendarFormat = format)), // Jika perlu ganti format
            ),

            // Judul "Hari ini" atau "Tanggal Terpilih"
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 25.0, 24.0, 15.0), // Tambah padding atas
              child: Text(
                // Gunakan DateUtils.isSameDay untuk perbandingan yang lebih aman
                DateUtils.isSameDay(_selectedDay, DateTime.now())
                    ? 'Jadwal Hari Ini' // Teks lebih deskriptif
                    : DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_selectedDay), // Format tanggal lengkap
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Gunakan DailyScheduleList widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0), // Beri padding horizontal
              child: DailyScheduleList(
                schedule: scheduleForSelectedDay,
                onItemTap: _handleScheduleItemTap, // Tambahkan callback tap
              ),
            ),

            const SizedBox(height: 30), // Jarak sebelum tombol

            // Gunakan GenerateMenuButton widget
            const GenerateMenuButton(),

            const SizedBox(height: 30), // Padding bawah setelah tombol
          ],
        ),
      ),
    );
  }
}