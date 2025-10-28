import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightDetailContent extends StatelessWidget {
  const WeightDetailContent({super.key});

  // --- Data Dummy ---
  final List<FlSpot> weightSpots = const [
    FlSpot(0, 157), FlSpot(1, 158), FlSpot(2, 156), FlSpot(3, 159),
    FlSpot(4, 157), FlSpot(5, 155), FlSpot(6, 156), FlSpot(7, 154),
    FlSpot(8, 156), FlSpot(9, 158), FlSpot(10, 155), FlSpot(11, 157),
  ];
  final List<Map<String, dynamic>> weightHistory = const [
    {'date': '26 Okt 2025', 'weight': 155.0},
    {'date': '19 Okt 2025', 'weight': 156.0},
    {'date': '12 Okt 2025', 'weight': 155.5},
    {'date': '05 Okt 2025', 'weight': 157.0},
  ];
  // --- Akhir Data Dummy ---

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Grafik Riwayat Berat Badan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              minY: 150, maxY: 160,
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey.shade200, strokeWidth: 1), horizontalInterval: 2),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 2, getTitlesWidget: (v,m) => Text('${v.toInt()} kg'))),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 25, interval: 2, getTitlesWidget: (v,m) {
                  const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
                  final index = v.toInt();
                  if (index >= 0 && index < labels.length) { return Padding( padding: const EdgeInsets.only(top: 8.0, right: 4.0), child: Text(labels[index], style: TextStyle(color: Colors.grey.shade600, fontSize: 10)), ); } return const Text('');
                })),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
              lineBarsData: [
                LineChartBarData(
                  spots: weightSpots,
                  isCurved: true, color: primaryColor, barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              // Bagian yang error ada di sini jika import fl_chart kurang
              lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipColor: (spot) => primaryColor.withOpacity(0.8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(1)} kg',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text('Riwayat Berat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: weightHistory.length,
            itemBuilder: (context, index) {
              final entry = weightHistory[index];
              return ListTile(
                dense: true,
                title: Text(entry['date']),
                trailing: Text('${entry['weight']} kg', style: const TextStyle(fontWeight: FontWeight.w500)),
                contentPadding: EdgeInsets.zero,
              );
            }
        )
      ],
    );
  }
}