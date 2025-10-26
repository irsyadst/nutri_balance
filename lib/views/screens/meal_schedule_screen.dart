import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/meal_models.dart';
import 'food_detail_screen.dart';

class MealScheduleScreen extends StatefulWidget {
  const MealScheduleScreen({super.key});

  @override
  State<MealScheduleScreen> createState() => _MealScheduleScreenState();
}

class _MealScheduleScreenState extends State<MealScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _weekDates = [];

  int _initialDateIndex = 3; // Indeks tanggal tengah

  // Data Jadwal Statis (Sementara)
  final Map<String, List<DailySchedule>> groupedSchedule = const {
    'Sarapan': [
      DailySchedule(mealName: 'Sarapan', time: '07:00am', foodName: 'Honey Pancake', calories: 230, iconAsset: 'pancake_icon'),
      DailySchedule(mealName: 'Sarapan', time: '07:30am', foodName: 'Coffee', calories: 20, iconAsset: 'coffee_icon'),
    ],
    'Makan Siang': [
      DailySchedule(mealName: 'Makan Siang', time: '01:00pm', foodName: 'Chicken Steak', calories: 500, iconAsset: 'chicken_icon'),
      DailySchedule(mealName: 'Makan Siang', time: '01:20pm', foodName: 'Milk', calories: 120, iconAsset: 'milk_icon'),
    ],
    'Snack': [
      DailySchedule(mealName: 'Snack', time: '04:30pm', foodName: 'Orange', calories: 140, iconAsset: 'orange_icon'),
      DailySchedule(mealName: 'Snack', time: '04:40pm', foodName: 'Apple Pie', calories: 140, iconAsset: 'apple_pie_icon'),
    ],
    'Makan Malam': [
      DailySchedule(mealName: 'Makan Malam', time: '07:10pm', foodName: 'Salad', calories: 120, iconAsset: 'salad_icon'),
      DailySchedule(mealName: 'Makan Malam', time: '08:10pm', foodName: 'Oatmeal', calories: 120, iconAsset: 'oatmeal_icon'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _generateWeekDates(_selectedDate);
  }

  void _generateWeekDates(DateTime centerDate) {
    setState(() {
      _weekDates.clear();
      DateTime startDate = centerDate.subtract(Duration(days: _initialDateIndex));
      for (int i = 0; i < 7; i++) {
        _weekDates.add(startDate.add(Duration(days: i)));
      }
    });
  }

  void _onDateSelected(DateTime date, {PageController? controller}) {
    setState(() {
      _selectedDate = date;
      if (controller != null && controller.hasClients) {
        int selectedIndex = _weekDates.indexWhere((d) => DateUtils.isSameDay(d, date));
        if (selectedIndex != -1 && selectedIndex != controller.page?.round()) {
          controller.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
      print("Tanggal dipilih: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}");
      // TODO: fetchMealScheduleForDate(_selectedDate);
    });
  }

  void _goToPreviousDay({PageController? controller}) {
    DateTime previousDay = _selectedDate.subtract(const Duration(days: 1));
    int previousIndex = _weekDates.indexWhere((d) => DateUtils.isSameDay(d, previousDay));
    if(previousIndex == -1) {
      _generateWeekDates(previousDay);
      // Pilih hari itu setelah generate (controller akan dibuat ulang di build)
      // Jadi kita hanya perlu set _selectedDate
      setState(() {
        _selectedDate = previousDay;
      });
      print("Tanggal dipilih (prev week): ${DateFormat('yyyy-MM-dd').format(_selectedDate)}");
      // TODO: fetchMealScheduleForDate(_selectedDate);
    } else {
      _onDateSelected(previousDay, controller: controller); // Gunakan controller yg ada
    }
  }

  void _goToNextDay({PageController? controller}) {
    DateTime nextDay = _selectedDate.add(const Duration(days: 1));
    int nextIndex = _weekDates.indexWhere((d) => DateUtils.isSameDay(d, nextDay));
    if(nextIndex == -1) {
      _generateWeekDates(nextDay);
      setState(() {
        _selectedDate = nextDay;
      });
      print("Tanggal dipilih (next week): ${DateFormat('yyyy-MM-dd').format(_selectedDate)}");
      // TODO: fetchMealScheduleForDate(_selectedDate);
    } else {
      _onDateSelected(nextDay, controller: controller); // Gunakan controller yg ada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Jadwal Makan', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: _buildDatePicker(context), // Date picker dibangun di sini
            ),
            const SizedBox(height: 20),
            _buildScheduleList(context),
            const SizedBox(height: 30),
            _buildNutritionalSummary(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- PERUBAHAN UTAMA: Pindahkan MediaQuery ke sini ---
  Widget _buildDatePicker(BuildContext context) {
    // Controller dibuat di sini menggunakan LayoutBuilder
    PageController dateScrollController;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.grey),
                  // Kita perlu akses ke controller saat tombol ditekan, jadi kita
                  // tidak bisa langsung memanggil _goToPreviousDay() di sini
                  // Solusi: Gunakan Builder atau State Management yang lebih baik nanti
                  // Untuk sementara, kita buat controller baru saat build date picker
                  onPressed: () {
                    // Kita perlu cara untuk mendapatkan controller yang aktif di PageView
                    // Ini cara sementara, idealnya pakai state management
                    _goToPreviousDay();
                  },
                ),
                Text(
                    DateFormat('MMMM yyyy', 'id_ID').format(_selectedDate),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  onPressed: () {
                    // Sama seperti tombol previous
                    _goToNextDay();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 80,
            child: LayoutBuilder( // Gunakan LayoutBuilder
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth; // Lebar parent (SizedBox)
                  // Hitung viewportFraction di sini
                  final calculatedViewportFraction = (60 / screenWidth) + 0.04;

                  // --- BUAT CONTROLLER DI SINI ---
                  // Dapatkan index terpilih saat ini SEBELUM membuat controller
                  int currentIndex = _weekDates.indexWhere((d) => DateUtils.isSameDay(d, _selectedDate));
                  if (currentIndex == -1) currentIndex = _initialDateIndex; // Fallback jika tidak ditemukan

                  dateScrollController = PageController(
                    initialPage: currentIndex, // Gunakan index saat ini
                    viewportFraction: calculatedViewportFraction.clamp(0.1, 1.0), // Batasi nilainya
                  );
                  // --- SELESAI MEMBUAT CONTROLLER ---

                  return PageView.builder(
                    controller: dateScrollController, // Gunakan controller yang baru dibuat
                    itemCount: _weekDates.length,
                    onPageChanged: (index) {
                      // Cek sederhana agar tidak setState saat generate ulang
                      if(index < _weekDates.length && !DateUtils.isSameDay(_weekDates[index], _selectedDate)) {
                        _onDateSelected(_weekDates[index]); // Tetap panggil _onDateSelected
                      }
                    },
                    itemBuilder: (context, index) {
                      final date = _weekDates[index];
                      final bool isSelected = DateUtils.isSameDay(date, _selectedDate);
                      final String dayName = DateFormat('E', 'id_ID').format(date);
                      final int dayNumber = date.day;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: _buildDateItem(
                            dayName,
                            dayNumber,
                            isSelected,
                            // Berikan controller ke onTap agar bisa animasi
                                () => _onDateSelected(date, controller: dateScrollController)
                        ),
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }


  // Widget _buildDateItem (tetap sama)
  Widget _buildDateItem(String day, int date, bool isSelected, VoidCallback onTap) {
    const activeColor = Color(0xFF007BFF);
    final borderColor = isSelected ? activeColor : Colors.grey.shade300;
    final bgColor = isSelected ? activeColor : Colors.white;
    final textColor = isSelected ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: TextStyle(color: textColor, fontSize: 14)),
            const SizedBox(height: 4),
            Text('$date', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  // --- Widget builder lainnya ( _buildScheduleList, _buildScheduleItem, _buildNutritionalSummary, _buildMacroBar) ---
  // --- Tetap sama seperti sebelumnya ---
  Widget _buildScheduleList(BuildContext context) {
    final scheduleToDisplay = groupedSchedule; // Masih dummy

    if (scheduleToDisplay.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(30.0),
        child: Text("Tidak ada jadwal makan untuk tanggal ini."),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: scheduleToDisplay.entries.map((entry) {
        final mealType = entry.key;
        final meals = entry.value;
        final totalCalories = meals.fold<int>(0, (sum, item) => sum + item.calories);
        final totalCount = meals.length;

        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mealType, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('$totalCount kali makan | $totalCalories kalori', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              ...meals.map((item) => _buildScheduleItem(context, item)).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScheduleItem(BuildContext context, DailySchedule item) {
    return ListTile(
      leading: Container(
        width: 50, height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.local_dining, color: Colors.grey), // Placeholder ikon
      ),
      title: Text(item.foodName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(item.time, style: TextStyle(color: Colors.grey.shade600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${item.calories} kkal', style: TextStyle(color: Colors.grey.shade600)),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailScreen(
            mealItem: MealItem(
                id: 'temp_${item.foodName.replaceAll(' ', '_')}',
                name: item.foodName, time: item.time, calories: item.calories, iconAsset: item.iconAsset,
                description: 'Deskripsi placeholder untuk ${item.foodName}.'
            )
        )));
      },
    );
  }

  Widget _buildNutritionalSummary() {
    final Map<String, double> nutrition = {
      'Kalori': 320, 'Protein': 300, 'Lemak': 140, 'Karbo': 140,
    };
    final Map<String, double> goals = {
      'Kalori': 1800, 'Protein': 350, 'Lemak': 200, 'Karbo': 400,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nutrisi Makanan Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ...nutrition.entries.map((entry) {
            final label = entry.key;
            final consumed = entry.value;
            final goal = goals[label] ?? 500;
            final progress = (consumed / goal).clamp(0.0, 1.0);
            Color color;
            if (label == 'Kalori') color = const Color(0xFFEF5350);
            else if (label == 'Protein') color = const Color(0xFF6A82FF);
            else if (label == 'Lemak') color = const Color(0xFFFFC107);
            else color = const Color(0xFF4CAF50);
            IconData icon;
            if (label == 'Kalori') icon = Icons.local_fire_department;
            else if (label == 'Protein') icon = Icons.set_meal;
            else if (label == 'Lemak') icon = Icons.egg;
            else icon = Icons.local_florist;
            final unit = (label == 'Kalori') ? 'kkal' : 'g';
            final displayValue = consumed.round();

            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: _buildMacroBar(label, icon, displayValue, unit, progress, color),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMacroBar(String label, IconData icon, int value, String unit, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 5),
                Icon(icon, size: 16, color: color),
              ],
            ),
            Text('$value $unit', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}