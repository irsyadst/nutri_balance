import 'package:flutter/material.dart';

class MacroBreakdownCard extends StatelessWidget {
  final String macroRatio;
  final double macroChangePercent;
  final Map<String, double> macroDataPercentage;

  const MacroBreakdownCard({
    super.key,
    required this.macroRatio,
    required this.macroChangePercent,
    required this.macroDataPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final percentColor = macroChangePercent >= 0 ? Colors.green.shade500 : Colors.red.shade400;
    final percentText = '${macroChangePercent >= 0 ? '+' : ''}${macroChangePercent.toStringAsFixed(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info Rasio Makro
        const Text('Makro', style: TextStyle(fontSize: 15, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(macroRatio, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          'Hari ini $percentText',
          style: TextStyle( fontSize: 14, color: percentColor, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),

        ...macroDataPercentage.entries.map((entry) {
          return _MacroBar(
            label: entry.key,
            percentage: entry.value,
            color: _getColorForMacro(entry.key, context),
          );
        }).toList(),
      ],
    );
  }

  Color _getColorForMacro(String label, BuildContext context) {
    switch (label.toLowerCase()) {
      case 'protein':
    return Theme.of(context).primaryColor;
      case 'karbohidrat':
      case 'carbs':
        return Colors.green.shade400;
      case 'lemak':
      case 'fats':
        return Colors.amber.shade400;
      default:
        return Colors.grey;
    }
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;

  const _MacroBar({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '$label (${percentage.toStringAsFixed(0)}%)',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700)
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}