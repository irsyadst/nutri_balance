import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CalorieDetailContent extends StatelessWidget {
  const CalorieDetailContent({super.key});

  // --- Data Dummy (Pindahkan ke sini atau terima dari parent) ---
  final List<FlSpot> dailyCalorieSpots = const [
    FlSpot(0, 1800), FlSpot(1, 2000), FlSpot(2, 1700),
    FlSpot(3, 1900), FlSpot(4, 2100), FlSpot(5, 1600),
    FlSpot(6, 1850),
  ];
  final Map<String, List<Map<String, dynamic>>> dailyIntake = const {
    'Sarapan': [{'name': 'Oatmeal', 'cal': 250}, {'name': 'Roti', 'cal': 150}],
    'Makan Siang': [{'name': 'Ayam Bakar', 'cal': 500}, {'name': 'Salad', 'cal': 150}],
    'Makan Malam': [{'name': 'Salmon', 'cal': 400}],
    'Makanan Ringan': [{'name': 'Apel', 'cal': 95}, {'name': 'Yoghurt', 'cal': 105}],
  };
  // --- Akhir Data Dummy ---

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Grafik Kalori Harian (7 Hari)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minY: 0,
              gridData: FlGridData(
                show: true, drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                horizontalInterval: 500,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 500, getTitlesWidget: (v,m) => Text('${v.toInt()}'))),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 25, interval: 1, getTitlesWidget: (v,m) => Text('H-${6-v.toInt()}'))),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: dailyCalorieSpots, isCurved: true, color: primaryColor, barWidth: 3,
                  dotData: const FlDotData(show: true), // Tampilkan titik di detail
                  belowBarData: BarAreaData(show: true, gradient: LinearGradient( colors: [primaryColor.withOpacity(0.3), primaryColor.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter, ),),
                ),
              ],
              lineTouchData: const LineTouchData(enabled: true),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text('Riwayat Asupan Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...dailyIntake.entries.expand((entry) {
          return [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...entry.value.map((food) => ListTile(
              dense: true,
              title: Text(food['name']),
              trailing: Text('${food['cal']} kkal', style: TextStyle(color: Colors.grey.shade600)),
              contentPadding: EdgeInsets.zero,
            )),
          ];
        }),
      ],
    );
  }
}