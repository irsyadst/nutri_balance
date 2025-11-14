// lib/views/widgets/statistics/calorie_detail_content.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nutri_balance/controllers/statistics_controller.dart';

class CalorieDetailContent extends StatelessWidget {
  final StatisticsController controller;

  const CalorieDetailContent({super.key, required this.controller});

  double _calculateInterval(double maxY) {
    if (maxY <= 0) return 100;
    if (maxY <= 200) return 50;
    if (maxY <= 600) return 100;
    if (maxY <= 1200) return 200;
    if (maxY <= 2000) return 500;
    return (maxY / 5).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final mealData = controller.calorieDataPerMeal;
    final totalCalories = controller.caloriesToday;

    final List<BarChartGroupData> barGroups = [];
    final mealOrder = ['Sarapan', 'Makan Siang', 'Makan Malam', 'Snack'];

    for (int i = 0; i < mealOrder.length; i++) {
      final mealType = mealOrder[i];
      final value = mealData[mealType] ?? 0.0;

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
    }
    final double maxY = barGroups.isEmpty ? 100 : controller.maxCaloriePerMeal * 1.2;
    final double leftInterval = _calculateInterval(maxY);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        const Text(
          'Distribusi Kalori',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 350,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
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
                        child: Text(shortText, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: leftInterval,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const Text('');
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                      );
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
              barTouchData: BarTouchData(
                enabled: false,
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),
        const Text(
          'Rincian Kalori per Sesi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: mealOrder.map((mealType) {
            final value = mealData[mealType] ?? 0.0;
            if (value <= 0) {
              return const SizedBox.shrink();
            }
            return _buildCalorieDetailRow(
              title: mealType,
              calories: value,
              color: _getColorForMeal(mealType),
            );
          }).toList(),
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

  Widget _buildCalorieDetailRow({
    required String title,
    required double calories,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${calories.round()} kkal',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}