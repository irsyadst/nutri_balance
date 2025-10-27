import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class MacroDetailContent extends StatelessWidget {
  const MacroDetailContent({super.key});

  // --- Data Dummy ---
  final Map<String, double> macroData = const {
    'Protein': 40,
    'Karbohidrat': 35,
    'Lemak': 25,
  };

  final Map<String, int> avgGramData = const {
    'Protein': 110,
    'Karbohidrat': 190,
    'Lemak': 55,
  };
  // --- Akhir Data Dummy ---

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Data dummy untuk Bar Chart mingguan (7 hari)
    final List<BarChartGroupData> weeklyMacroBars = List.generate(7, (index) {
      final prot = Random().nextDouble() * 100 + 50; // Gram
      final carb = Random().nextDouble() * 150 + 80;
      final fat = Random().nextDouble() * 50 + 20;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: prot,
            color: primaryColor,
            width: 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ), // Protein
          BarChartRodData(
            toY: carb,
            color: Colors.green.shade400,
            width: 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ), // Karbo
          BarChartRodData(
            toY: fat,
            color: Colors.amber.shade400,
            width: 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ), // Lemak
        ],
        barsSpace: 4, // Jarak antar bar dalam grup
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribusi Makro Hari Ini (%)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        // === PIE CHART ===
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 40,
              sections: macroData.entries.map((entry) {
                Color color;
                if (entry.key == 'Protein') {
                  color = primaryColor;
                } else if (entry.key == 'Karbohidrat') {
                  color = Colors.green.shade400;
                } else {
                  color = Colors.amber.shade400;
                }

                return PieChartSectionData(
                  value: entry.value,
                  color: color,
                  title: '${entry.value.toStringAsFixed(0)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 2)],
                  ),
                );
              }).toList(),
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {},
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // === RATA-RATA MINGGUAN ===
        const Text(
          'Rata-rata Mingguan (Gram)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ...avgGramData.entries.map(
              (entry) => ListTile(
            dense: true,
            title: Text(entry.key),
            trailing: Text(
              '${entry.value} g',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),

        const SizedBox(height: 30),

        // === BAR CHART ===
        const Text(
          'Asupan Makro Mingguan (Gram)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 300,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: Colors.grey.shade200,
                  strokeWidth: 1,
                ),
                horizontalInterval: 50,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    interval: 50,
                    getTitlesWidget: (v, meta) =>
                        Text('${v.toInt()}g', style: const TextStyle(fontSize: 12)),
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
              barGroups: weeklyMacroBars,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) =>
                      Colors.black.withOpacity(0.7),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String label;
                    if (rod.color == primaryColor) {
                      label = 'Protein';
                    } else if (rod.color == Colors.green.shade400) {
                      label = 'Karbohidrat';
                    } else {
                      label = 'Lemak';
                    }
                    return BarTooltipItem(
                      '$label: ${rod.toY.toStringAsFixed(0)} g',
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
      ],
    );
  }
}
