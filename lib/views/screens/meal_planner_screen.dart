import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import '../../models/meal_models.dart';
import 'food_category_screen.dart'; 
import 'meal_schedule_screen.dart'; 

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  final List<MealItem> todayMeals = const [
    MealItem(
      id: '1',
      name: 'Salmon Nigiri',
      time: 'Hari ini | Jam 7 pagi',
      calories: 300,
      iconAsset: 'assets/images/salmon_icon.png', 
      protein: 30, fat: 15, carbs: 20
    ),
    MealItem(
      id: '2',
      name: 'Susu Rendah Lemak',
      time: 'Hari ini | Jam 8 pagi',
      calories: 120,
      iconAsset: 'assets/images/milk_icon.png', 
      protein: 8, fat: 2, carbs: 10
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Meal Planner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grafik Nutrisi Makanan
            _buildNutritionChart(context),
            const SizedBox(height: 30),

            // Jadwal Makan Harian Button (Diubah menjadi card)
            _buildDailyScheduleCard(context),
            const SizedBox(height: 30),

            // Today Meals Header
            _buildTodayMealsHeader(context),
            const SizedBox(height: 15),

            // Today Meals List
            ...todayMeals.map((meal) => _buildMealListTile(context, meal)).toList(),
            const SizedBox(height: 40),

            // Find Something to Eat
            _buildFindSomethingToEatSection(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // === WIDGET PEMBANGUN ===

  Widget _buildNutritionChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Nutrisi Makanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text('Weekly', style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold)),
                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF007BFF)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Line Chart Container
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minX: 0, maxX: 6, minY: 0, maxY: 100, // Y axis 0% to 100%
              // Titik di sumbu Y (20%, 40%, 60%, 80%, 100%)
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, interval: 1, reservedSize: 25,
                    getTitlesWidget: (value, meta) {
                      const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                      // Tandai hari Kamis (index 3) dengan warna biru
                      final isToday = value.toInt() == 3; 
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: Text(
                          days[value.toInt()], 
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? Colors.blue : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, interval: 20, reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: Text('${value.toInt()}%', style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              // Grid disesuaikan agar hanya horizontal
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.3), 
                  strokeWidth: 1, 
                  dashArray: [5, 5]
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: _getLineBarsData(),
              lineTouchData: const LineTouchData(enabled: false), // Nonaktifkan pop-up touch
            ),
          ),
        ),
        // Legend di bawah grafik
        _buildChartLegend(),
      ],
    );
  }

  List<LineChartBarData> _getLineBarsData() {
    // Data dummy untuk empat garis
    return [
      // 1. Calories (Biru Tua)
      LineChartBarData(
        spots: const [FlSpot(0, 70), FlSpot(1, 82), FlSpot(2, 60), FlSpot(3, 40), FlSpot(4, 30), FlSpot(5, 50), FlSpot(6, 60)],
        isCurved: true,
        color: const Color(0xFF007BFF),
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: (index == 1) ? 4 : 3, // Circle di spot 1 (Mon)
            color: const Color(0xFF007BFF),
            strokeWidth: 0,
          ),
        ),
        belowBarData: BarAreaData(show: false),
      ),
      // 2. Sugar (Merah Muda)
      LineChartBarData(
        spots: const [FlSpot(0, 50), FlSpot(1, 45), FlSpot(2, 39), FlSpot(3, 30), FlSpot(4, 35), FlSpot(5, 40), FlSpot(6, 45)],
        isCurved: true,
        color: const Color(0xFFFF4081),
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: (index == 2) ? 4 : 3, // Circle di spot 2 (Tue)
            color: const Color(0xFFFF4081),
            strokeWidth: 0,
          ),
        ),
        belowBarData: BarAreaData(show: false),
      ),
      // 3. Fibre (Biru Muda/Cyan)
      LineChartBarData(
        spots: const [FlSpot(0, 60), FlSpot(1, 75), FlSpot(2, 88), FlSpot(3, 80), FlSpot(4, 70), FlSpot(5, 65), FlSpot(6, 70)],
        isCurved: true,
        color: const Color(0xFF00BCD4),
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: (index == 2) ? 4 : 3, // Circle di spot 2 (Tue)
            color: const Color(0xFF00BCD4),
            strokeWidth: 0,
          ),
        ),
        belowBarData: BarAreaData(show: false),
      ),
      // 4. Fats (Kuning/Oranye)
      LineChartBarData(
        spots: const [FlSpot(0, 40), FlSpot(1, 55), FlSpot(2, 45), FlSpot(3, 42), FlSpot(4, 50), FlSpot(5, 55), FlSpot(6, 60)],
        isCurved: true,
        color: const Color(0xFFFFC107),
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: (index == 3) ? 4 : 3, // Circle di spot 3 (Wed)
            color: const Color(0xFFFFC107),
            strokeWidth: 0,
          ),
        ),
        belowBarData: BarAreaData(show: false),
      ),
    ];
  }

  Widget _buildChartLegend() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Wrap(
        spacing: 15.0,
        runSpacing: 5.0,
        children: [
          _buildTrendLabel('Calories', '82%↑', const Color(0xFF007BFF), true),
          _buildTrendLabel('Sugar', '39%↓', const Color(0xFFFF4081), false),
          _buildTrendLabel('Fibre', '88%↑', const Color(0xFF00BCD4), true),
          _buildTrendLabel('Fats', '42%↓', const Color(0xFFFFC107), false),
        ],
      ),
    );
  }

  Widget _buildTrendLabel(String label, String value, Color color, bool isUp) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Icon(
          isUp ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14,
          color: color,
        ),
      ],
    );
  }

  Widget _buildDailyScheduleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3FF), // Latar belakang biru muda
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Jadwal Makan Harian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          ElevatedButton(
            onPressed: () {
              // Navigasi ke Jadwal Makan
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MealScheduleScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Check', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayMealsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Today Meals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // Dropdown Meal Type untuk navigasi ke Food Category Screen
        DropdownButton<String>(
          value: 'Sarapan',
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF007BFF)),
          underline: const SizedBox(),
          style: const TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold, fontSize: 16),
          items: <String>['Sarapan', 'Makan Siang', 'Makan Malam'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? newValue) {
            // Navigasi ke Halaman Kategori Makanan berdasarkan pilihan
            Navigator.push(context, MaterialPageRoute(builder: (context) => FoodCategoryScreen(mealType: newValue ?? 'Sarapan')));
          },
        ),
      ],
    );
  }

  Widget _buildMealListTile(BuildContext context, MealItem meal) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Row(
        children: [
          // Icon Placeholder
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.ramen_dining, color: Colors.grey),
          ),
          const SizedBox(width: 15),
          // Detail Makanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(meal.time, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              ],
            ),
          ),
          // Icon Lonceng/Notifikasi
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFindSomethingToEatSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Find Something to Eat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        SizedBox(
          height: 200, // Ketinggian tetap untuk scroll view
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryCard(
                context, 
                'Sarapan', 
                '120+ Makanan', 
                Colors.blue.shade50, 
                const Color(0xFF6A82FF)
              ),
              const SizedBox(width: 15),
              _buildCategoryCard(
                context, 
                'Makan siang', 
                '130+ Makanan', 
                Colors.purple.shade50, 
                const Color(0xFFFF4081)
              ),
              const SizedBox(width: 15),
              _buildCategoryCard(
                context, 
                'Makan Malam', 
                '90+ Makanan', 
                Colors.green.shade50, 
                const Color(0xFF4CAF50)
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, String subtitle, Color bgColor, Color btnColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Gambar Placeholder
          Container(
            width: double.infinity,
            height: 80,
            color: Colors.transparent, 
            child: const Icon(Icons.food_bank, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 10),
          // Tombol Select
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FoodCategoryScreen(mealType: title)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor.withOpacity(0.8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Select', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}