// lib/views/widgets/statistics/summary/calorie_intake_card.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CalorieIntakeCard extends StatelessWidget {
  final int caloriesToday;
  final double calorieChangePercent;
  final Map<String, double> calorieDataPerMeal;
  final double maxCaloriePerMeal;

  const CalorieIntakeCard({
    super.key,
    required this.caloriesToday,
    required this.calorieChangePercent,
    required this.calorieDataPerMeal,
    required this.maxCaloriePerMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(), // Header Anda yang sudah tanpa persentase
          const SizedBox(height: 24),
          _buildChart(), // Chart yang sudah diperbaiki
        ],
      ),
    );
  }
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${caloriesToday.round()}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'kkal (Rata-rata)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChart() {
    final mealOrder = ['Sarapan', 'Makan Siang', 'Makan Malam', 'Snack'];
    final List<BarChartGroupData> barGroups = [];

    // PERBAIKAN 1: Buat semua 4 bar, meskipun datanya 0
    for (int i = 0; i < mealOrder.length; i++) {
      final mealType = mealOrder[i];
      final value = calorieDataPerMeal[mealType] ?? 0.0;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value,
              color: _getColorForMeal(mealType),
              width: 14, // Bar lebih ramping untuk summary
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    // Tentukan nilai Y maksimum
    final double maxY = maxCaloriePerMeal == 0 ? 100 : maxCaloriePerMeal * 1.2;

    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  // PERBAIKAN 2: Logika label yang benar
                  String shortText = '';
                  int index = value.toInt();
                  if (index >= 0 && index < mealOrder.length) {
                    String fullText = mealOrder[index];
                    switch (fullText) {
                      case 'Sarapan':
                        shortText = 'Pagi';
                        break;
                      case 'Makan Siang':
                        shortText = 'Siang';
                        break;
                      case 'Makan Malam':
                        shortText = 'Malam';
                        break;
                      case 'Snack':
                        shortText = 'Snack';
                        break;
                    }
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(shortText, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  );
                },
                reservedSize: 20,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false), // Sembunyikan grid di summary
          barTouchData: BarTouchData(enabled: false),
        ),
      ),
    );
  }

  // Helper untuk warna bar
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