import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../models/meal_models.dart';
import 'generate_menu_screen.dart';

class MealPackageScreen extends StatefulWidget {
  const MealPackageScreen({super.key});

  @override
  State<MealPackageScreen> createState() => _MealPackageScreenState();
}

class _MealPackageScreenState extends State<MealPackageScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // --- Data Dummy (Ganti dengan data asli dari state/controller) ---
  final Map<String, List<DailySchedule>> dummySchedule = const {
    'Sarapan': [
      DailySchedule(mealName: 'Sarapan', time: '07:00am', foodName: 'Honey Pancake', calories: 1000, iconAsset: 'pancake_icon'),
    ],
    'Makan Siang': [
      DailySchedule(mealName: 'Makan Siang', time: '01:00pm', foodName: 'Chicken Steak', calories: 1000, iconAsset: 'chicken_icon'),
    ],
    'Makan Malam': [
      DailySchedule(mealName: 'Makan Malam', time: '07:10pm', foodName: 'Salad', calories: 1000, iconAsset: 'salad_icon'),
    ],
  };

  // TODO: Buat fungsi untuk mengambil data berdasarkan _selectedDay
  Map<String, List<DailySchedule>> _getScheduleForDay(DateTime day) {
    return dummySchedule;
  }
  // --- Akhir Data Dummy ---


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _getScheduleForDay(selectedDay); // Panggil pengambilan data di sini
      });
    }
  }

  void _generateAutomaticMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GenerateMenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleForSelectedDay = _getScheduleForDay(_selectedDay);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if(Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Paket Makan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        // Padding dipindahkan ke dalam Column agar tombol juga ikut
        // padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0), // Hapus padding di sini
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kalender
            _buildCalendar(), // Tidak perlu padding horizontal di sini

            // Judul "Hari ini" atau "Tanggal Terpilih"
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 15.0),
              child: Text(
                DateUtils.isSameDay(_selectedDay, DateTime.now()) ? 'Hari ini' : DateFormat('d MMMM yyyy', 'id_ID').format(_selectedDay),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Daftar Jadwal Makan
            _buildScheduleList(context, scheduleForSelectedDay), // Padding sudah diatur di dalam fungsi ini

            // --- PERUBAHAN: Tombol dipindahkan ke sini ---
            const SizedBox(height: 30), // Jarak sebelum tombol
            Padding( // Beri padding horizontal untuk tombol
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildActionButtons(),
            ),
            const SizedBox(height: 30), // Padding bawah setelah tombol
            // --- AKHIR PERUBAHAN ---
          ],
        ),
      ),
      // --- PERUBAHAN: Hapus bottomSheet ---
      // bottomSheet: _buildActionButtons(),
      // --- AKHIR PERUBAHAN ---
    );
  }

  // === WIDGET BUILDER ===

  Widget _buildCalendar() {
    // ... (Kode _buildCalendar tidak berubah) ...
    final primaryColor = Theme.of(context).primaryColor;

    return TableCalendar(
      locale: 'id_ID', // Gunakan locale Indonesia
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: _onDaySelected,
      onPageChanged: (focusedDay) {
        // Hanya update _focusedDay agar kalender berpindah bulan
        // Tidak perlu setState karena tidak mengubah UI secara langsung
        _focusedDay = focusedDay;
      },
      headerStyle: HeaderStyle(
        titleCentered: true,
        titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
        titleTextStyle: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
        formatButtonVisible: false,
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.grey),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.black54),
        weekdayStyle: TextStyle(color: Colors.black54),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(color: Colors.black),
        selectedDecoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        outsideDaysVisible: false,
      ),
    );
  }

  Widget _buildScheduleList(BuildContext context, Map<String, List<DailySchedule>> schedule) {
    // ... (Kode _buildScheduleList tidak berubah) ...
    final List<Widget> mealWidgets = schedule.entries.map((entry) {
      final mealType = entry.key;
      final totalCalories = entry.value.fold<int>(0, (sum, item) => sum + item.calories);
      return _buildScheduleItem(
        context,
        mealType,
        totalCalories,
      );
    }).toList();

    if (mealWidgets.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Center(child: Text("Tidak ada jadwal makan untuk tanggal ini.", style: TextStyle(color: Colors.grey))),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mealWidgets.length,
        itemBuilder: (context, index) => mealWidgets[index],
        separatorBuilder: (context, index) => const SizedBox(height: 15),
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, String mealType, int calories) {
    // ... (Kode _buildScheduleItem tidak berubah) ...
    IconData iconData;
    switch (mealType) {
      case 'Sarapan':
        iconData = Icons.wb_sunny_outlined;
        break;
      case 'Makan Siang':
        iconData = Icons.restaurant_menu_outlined;
        break;
      case 'Makan Malam':
        iconData = Icons.nights_stay_outlined;
        break;
      case 'Snack':
        iconData = Icons.fastfood_outlined;
        break;
      default:
        iconData = Icons.circle_outlined;
    }

    return InkWell(
      onTap: () {
        // TODO: Navigasi ke halaman detail jadwal makan atau lakukan aksi lain
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade100,
              child: Icon(iconData, color: Colors.grey.shade600, size: 28),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mealType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text('$calories cal', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- PERUBAHAN: _buildActionButtons sekarang tidak perlu container khusus ---
  Widget _buildActionButtons() {
    return Row( // Langsung return Row
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _generateAutomaticMenu,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Hasilkan Menu Otomatis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
      ],
    );
  }
}