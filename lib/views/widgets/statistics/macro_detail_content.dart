// lib/views/widgets/statistics/macro_detail_content.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nutri_balance/controllers/statistics_controller.dart';

class MacroDetailContent extends StatelessWidget {
  final StatisticsController controller;

  const MacroDetailContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final percentages = controller.macroDataPercentage;
    final totalCalories = controller.caloriesToday;
    final List<PieChartSectionData> sections = [];

    final macroData = {
      'Karbohidrat': {'value': percentages['Karbohidrat'] ?? 0.0, 'color': Colors.blue.shade400},
      'Protein': {'value': percentages['Protein'] ?? 0.0, 'color': Colors.green.shade400},
      'Lemak': {'value': percentages['Lemak'] ?? 0.0, 'color': Colors.orange.shade400},
    };

    final double totalCarbs = (totalCalories * ((macroData['Karbohidrat']!['value']! as double) / 100)) / 4;
    final double totalProtein = (totalCalories * ((macroData['Protein']!['value']! as double) / 100)) / 4;
    final double totalFats = (totalCalories * ((macroData['Lemak']!['value']! as double) / 100)) / 9;


    final double totalGrams = totalCarbs + totalProtein + totalFats;

    macroData.forEach((key, data) {
      final value = data['value'] as double;
      if (value > 0) {
        sections.add(
          PieChartSectionData(
            color: data['color'] as Color,
            value: value,
            title: '${value.toStringAsFixed(0)}%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: totalGrams <= 0
              ? const Center(child: Text('Tidak ada data makro untuk periode ini.'))
              : PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 60,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: macroData.entries.map((entry) {
            return _Indicator(
              color: entry.value['color'] as Color,
              text: entry.key,
              isSquare: false,
              size: 14,
            );
          }).toList(),
        ),
        const SizedBox(height: 30),

        const Text(
          'Rincian Total (Rata-rata Harian)',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _MacroInfoCard(
          title: 'Karbohidrat',
          grams: totalCarbs,
          color: Colors.blue.shade400,
        ),
        _MacroInfoCard(
          title: 'Protein',
          grams: totalProtein,
          color: Colors.green.shade400,
        ),
        _MacroInfoCard(
          title: 'Lemak',
          grams: totalFats,
          color: Colors.orange.shade400,
        ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;

  const _Indicator({
    required this.color,
    required this.text,
    this.isSquare = false,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

class _MacroInfoCard extends StatelessWidget {
  final String title;
  final double grams;
  final Color color;

  const _MacroInfoCard({
    required this.title,
    required this.grams,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
            '${grams.toStringAsFixed(1)} g',
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