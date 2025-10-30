// lib/views/screens/meal_package_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart'; // Dibutuhkan oleh MealCalendar
import '../../models/meal_models.dart'; // Masih dibutuhkan oleh DailyScheduleList
// Import widget
import '../widgets/meal_package/meal_calendar.dart';
import '../widgets/meal_package/daily_schedule_list.dart';
import '../widgets/meal_package/generate_menu_button.dart';
// Import controller baru
import '../../controllers/meal_package_controller.dart';

class MealPackageScreen extends StatefulWidget {
  const MealPackageScreen({super.key});

  @override
  State<MealPackageScreen> createState() => _MealPackageScreenState();
}

class _MealPackageScreenState extends State<MealPackageScreen> {
  // Buat instance controller
  late MealPackageController _controller;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller
    _controller = MealPackageController();

    // (Opsional) Tambahkan listener untuk menampilkan SnackBar jika ada error
    _controller.addListener(_handleControllerChanges);
  }

  // (Opsional) Listener untuk menampilkan SnackBar jika ada error
  void _handleControllerChanges() {
    if (_controller.status == MealPackageStatus.failure &&
        _controller.errorMessage != null) {
      // Tampilkan SnackBar setelah frame selesai dibangun
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_controller.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(
        _handleControllerChanges); // Hapus listener opsional
    _controller.dispose(); // Jangan lupa dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan ListenableBuilder untuk mendengarkan perubahan dari controller
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        // Tentukan konten body berdasarkan status controller
        Widget bodyContent;

        if (_controller.status == MealPackageStatus.loading) {
          // Tampilkan loading indicator di tengah
          bodyContent = const Center(child: CircularProgressIndicator());
        } else if (_controller.status == MealPackageStatus.failure) {
          // Tampilkan pesan error dan tombol refresh
          bodyContent = Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    _controller.errorMessage ?? 'Gagal memuat jadwal.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    onPressed:
                    _controller.fetchSchedules, // Panggil fetchSchedules lagi
                  ),
                ],
              ),
            ),
          );
        } else {
          // Konten utama jika status success
          bodyContent = SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gunakan MealCalendar widget, ambil data dari controller
                MealCalendar(
                  focusedDay: _controller.focusedDay,
                  selectedDay: _controller.selectedDay,
                  calendarFormat: _controller.calendarFormat,
                  onDaySelected:
                  _controller.onDaySelected, // Panggil method controller
                  onPageChanged: _controller
                      .onCalendarPageChanged, // Panggil method controller
                  onFormatChanged:
                  _controller.onFormatChanged, // Panggil method controller
                ),

                // Judul "Hari ini" atau "Tanggal Terpilih"
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 25.0, 24.0, 15.0),
                  child: Text(
                    // Gunakan DateUtils untuk perbandingan yang lebih aman
                    DateUtils.isSameDay(
                        _controller.selectedDay, DateTime.now())
                        ? 'Jadwal Hari Ini' // Teks lebih deskriptif
                        : DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                        .format(_controller.selectedDay), // Format tanggal
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                // Gunakan DailyScheduleList widget, ambil data dari controller
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DailyScheduleList(
                    schedule: _controller
                        .scheduleForSelectedDay, // Ambil data dari controller
                    onItemTap: _controller
                        .handleScheduleItemTap, // Panggil method controller
                  ),
                ),

                const SizedBox(height: 30), // Jarak sebelum tombol

                // Gunakan GenerateMenuButton widget
                const GenerateMenuButton(),

                const SizedBox(height: 30), // Padding bawah setelah tombol
              ],
            ),
          );
        }

        // Scaffold (struktur layar) tetap di sini
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Jadwal Makan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.grey.shade100,
          ),
          body: bodyContent, // Tampilkan konten yang sesuai (loading/error/data)
        );
      }, // Akhir builder ListenableBuilder
    );
  }
}