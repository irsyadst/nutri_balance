// lib/views/widgets/statistics/calorie_detail_content.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nutri_balance/controllers/statistics_controller.dart';

class CalorieDetailContent extends StatelessWidget {
  final StatisticsController controller;

  const CalorieDetailContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Ambil data dari controller
    final mealData = controller.calorieDataPerMeal;
    final totalCalories = controller.caloriesToday;

    // Siapkan data untuk Bar Chart
    final List<BarChartGroupData> barGroups = [];
    int i = 0;

    // Tentukan urutan meal
    final mealOrder = ['Sarapan', 'Makan Siang', 'Makan Malam', 'Snack'];

    for (var mealType in mealOrder) {
      final value = mealData[mealType] ?? 0.0;
      if (value > 0) { // Hanya tampilkan jika ada data
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: value,
                color: _getColorForMeal(mealType),
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        );
        i++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Judul Total Kalori
        Text(
          'Total Asupan Kalori',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${totalCalories.round()} kkal',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),

        // 2. Bar Chart
        Text(
          'Rincian per Waktu Makan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: barGroups.isEmpty
              ? Center(child: Text('Tidak ada data kalori untuk periode ini.'))
              : BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: controller.maxCaloriePerMeal, // Ambil dari controller
              barGroups: barGroups,
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      String text = '';
                      int index = value.toInt();
                      var activeMeals = mealOrder.where((m) => (mealData[m] ?? 0.0) > 0).toList();
                      if (index < activeMeals.length) {
                        text = activeMeals[index];
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: Text(text.split(' ').first, style: const TextStyle(fontSize: 12)),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const Text('');
                      if (value % (controller.maxCaloriePerMeal / 5) < 100) {
                        return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorForMeal(String mealType) {
    switch (mealType) {
      case 'Sarapan':
        return Colors.blue.shade300;
      case 'Makan Siang':
        return Colors.green.shade400;
      case 'Makan Malam':
        return Colors.orange.shade400;
      case 'Snack':
        return Colors.purple.shade300;
      default:
        return Colors.grey.shade400;
    }
  }
}