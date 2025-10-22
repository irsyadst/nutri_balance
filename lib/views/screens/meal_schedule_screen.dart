import 'package:flutter/material.dart';
import '../../models/meal_models.dart';
import 'food_detail_screen.dart'; // Asumsikan Anda ingin menavigasi ke detail makanan

class MealScheduleScreen extends StatelessWidget {
  const MealScheduleScreen({super.key});

  // Data Jadwal Statis yang dikelompokkan
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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker Section
            _buildDatePicker(context),
            const SizedBox(height: 30),

            // Schedule List Section
            _buildScheduleList(context),
            const SizedBox(height: 30),

            // Nutritional Summary Section
            _buildNutritionalSummary(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // === WIDGET PEMBANGUN (BUILDERS) ===

  Widget _buildDatePicker(BuildContext context) {
    // Data dummy untuk kalender
    final List<Map<String, dynamic>> dates = [
      {'day': 'Rabu', 'date': 15, 'active': false},
      {'day': 'Kamis', 'date': 16, 'active': false},
      {'day': 'Jumat', 'date': 17, 'active': true}, // Hari aktif
      {'day': 'Sabtu', 'date': 18, 'active': false},
      {'day': 'Min', 'date': 19, 'active': false},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.arrow_back_ios, size: 18, color: Colors.grey),
              const Text('Oktober 2025', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final item = dates[index];
                return _buildDateItem(item['day'], item['date'], item['active']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, int date, bool isSelected) {
    const activeColor = Color(0xFF007BFF);
    final borderColor = isSelected ? activeColor : Colors.grey.shade300;

    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: isSelected ? activeColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 14)),
          const SizedBox(height: 4),
          Text('$date', style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildScheduleList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSchedule.entries.map((entry) {
        final mealType = entry.key;
        final meals = entry.value;

        // Hitung total kalori untuk header meal
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
              // Daftar makanan untuk meal type ini
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
        // Placeholder untuk ikon makanan
        child: const Icon(Icons.local_dining, color: Colors.grey),
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
        // Navigasi ke halaman detail makanan (FoodDetailScreen)
        // Di sini kita memerlukan data MealItem lengkap, menggunakan placeholder saja:
        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailScreen(
          mealItem: MealItem(
            id: 'temp', name: item.foodName, time: item.time, calories: item.calories, iconAsset: item.iconAsset,
            description: 'Deskripsi placeholder untuk ${item.foodName}.'
          )
        )));
      },
    );
  }

  Widget _buildNutritionalSummary() {
    // Data Nutrisi Statis
    final Map<String, double> nutrition = {
      'Kalori': 320,
      'Protein': 300,
      'Lemak': 140,
      'Karbo': 140,
    };
    final Map<String, double> goals = {
      'Kalori': 1800, // Total goal harian
      'Protein': 350,
      'Lemak': 200,
      'Karbo': 400,
    };
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nutrisi Makanan Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          
          // Kartu ringkasan untuk setiap makro
          ...nutrition.entries.map((entry) {
            final label = entry.key;
            final consumed = entry.value;
            final goal = goals[label] ?? 500;
            final progress = (consumed / goal).clamp(0.0, 1.0);
            
            Color color;
            if (label == 'Kalori') color = const Color(0xFFEF5350); // Merah
            else if (label == 'Protein') color = const Color(0xFF6A82FF); // Biru
            else if (label == 'Lemak') color = const Color(0xFFFFC107); // Kuning
            else color = const Color(0xFF4CAF50); // Hijau (Karbo)

            IconData icon;
            if (label == 'Kalori') icon = Icons.local_fire_department;
            else if (label == 'Protein') icon = Icons.set_meal;
            else if (label == 'Lemak') icon = Icons.egg;
            else icon = Icons.local_florist;

            // Satuan berbeda untuk kalori
            final unit = (label == 'Kalori') ? 'kkal' : 'g';
            final displayValue = (label == 'Kalori') ? consumed.round() : consumed.round();

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