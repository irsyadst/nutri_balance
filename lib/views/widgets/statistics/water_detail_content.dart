import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class WaterDetailContent extends StatelessWidget {
  const WaterDetailContent({super.key});

  // --- Data Dummy ---
  final List<Map<String, dynamic>> waterLog = const [
    {'time': '08:00', 'amount': 500},
    {'time': '10:30', 'amount': 300},
    {'time': '13:00', 'amount': 500},
    {'time': '15:45', 'amount': 400},
    {'time': '18:10', 'amount': 300},
    {'time': '20:00', 'amount': 250},
  ];

  final double waterTarget = 3.0; // Target Liter
  // --- Akhir Data Dummy ---

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Generate data batang untuk grafik
    final List<BarChartGroupData> waterBarsDetail = List.generate(7, (index) {
      final liters = (Random().nextDouble() * 2.5) + 1.0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: liters,
            color: primaryColor,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Grafik Asupan Air Harian (Minggu Ini)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        // Grafik batang
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: waterTarget + 0.5,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: Colors.grey.shade200,
                  strokeWidth: 1,
                ),
                horizontalInterval: 1,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    interval: 1,
                    getTitlesWidget: (v, meta) =>
                        Text('${v.toStringAsFixed(1)}L'),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    getTitlesWidget: (v, meta) {
                      const days = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
                      final index = v.toInt();
                      if (index >= 0 && index < days.length) {
                        return Text(
                          days[index],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: waterBarsDetail,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => primaryColor.withOpacity(0.8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toStringAsFixed(1)} L',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          'Log Minum Hari Ini',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Log minum
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: waterLog.length,
          itemBuilder: (context, index) {
            final entry = waterLog[index];
            return ListTile(
              dense: true,
              leading: Icon(Icons.access_time_filled,
                  size: 20, color: Colors.blue.shade300),
              title: Text(entry['time']),
              trailing: Text(
                '${entry['amount']} ml',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              contentPadding: EdgeInsets.zero,
            );
          },
        ),
      ],
    );
  }
}
