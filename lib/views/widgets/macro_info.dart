import 'package:flutter/material.dart';

class MacroInfo extends StatelessWidget {
  final String title; final double value, total; final Color color;
  const MacroInfo({super.key, required this.title, required this.value, required this.total, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text('${value.toInt()}/${total.toInt()}g', style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 5),
      LinearProgressIndicator(
        value: value/total,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(color),
      )
    ]);
  }
}
