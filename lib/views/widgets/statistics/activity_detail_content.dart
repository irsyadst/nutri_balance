import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ActivityDetailContent extends StatelessWidget {
  ActivityDetailContent({super.key});

  // --- Data Dummy ---
  final List<Map<String, dynamic>> activityHistory = [
    {'date': '27 Okt 2025', 'steps': 5000, 'duration': 45, 'distance': 2.5},
    {'date': '26 Okt 2025', 'steps': 4500, 'duration': 40, 'distance': 2.2},
    {'date': '25 Okt 2025', 'steps': 6000, 'duration': 55, 'distance': 3.0},
    {'date': '24 Okt 2025', 'steps': 3000, 'duration': 25, 'distance': 1.5},
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Buat data bar chart langkah harian dummy
    final List<BarChartGroupData> stepBarsDetail = List.generate(7, (index) {
      final steps = Random().nextInt(6001) + 2000;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: steps.toDouble(),
            color: primaryColor,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Langkah Harian (Minggu Ini)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10000,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  ),
                  horizontalInterval: 2000,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 2000,
                      getTitlesWidget: (value, meta) =>
                          Text('${(value / 1000).toInt()}k'),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      getTitlesWidget: (value, meta) {
                        const days = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
                        return Text(days[value.toInt()]);
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: stepBarsDetail,
                barTouchData: BarTouchData(enabled: true),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Riwayat Aktivitas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activityHistory.length,
            itemBuilder: (context, index) {
              final entry = activityHistory[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    entry['date'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${NumberFormat.decimalPattern('id_ID').format(entry['steps'])} langkah • '
                        '${entry['distance']} mil • ${entry['duration']} menit',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
