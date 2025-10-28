import 'package:flutter/material.dart';

class NewCalculationsSection extends StatelessWidget {
  final Map<String, dynamic> calculations;
  final bool applyNewCalculations;
  final ValueChanged<bool?> onApplyChanged;

  const NewCalculationsSection({
    super.key,
    required this.calculations,
    required this.applyNewCalculations,
    required this.onApplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Format rasio makro (Consider moving this logic to where calculations are made)
    final protPercent = calculations.containsKey('proteins') && calculations.containsKey('calories') && calculations['calories'] > 0
        ? ((calculations['proteins'] * 4) / calculations['calories'] * 100).round()
        : 0;
    final carbPercent = calculations.containsKey('carbs') && calculations.containsKey('calories') && calculations['calories'] > 0
        ? ((calculations['carbs'] * 4) / calculations['calories'] * 100).round()
        : 0;
    final fatPercent = calculations.containsKey('fats') && calculations.containsKey('calories') && calculations['calories'] > 0
        ? ((calculations['fats'] * 9) / calculations['calories'] * 100).round()
        : 0;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hasil Kalkulasi Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildCalculationTile('BMI', calculations['bmi'] ?? 'N/A'),
        _buildCalculationTile('Target Harian', '${calculations['calories'] ?? 'N/A'} kkal'),
        _buildCalculationTile('Makronutrisi', '$carbPercent% Karbo, $protPercent% Prot, $fatPercent% Lemak'),
        const SizedBox(height: 10),
        CheckboxListTile(
          title: const Text('Terapkan kalkulasi baru', style: TextStyle(fontWeight: FontWeight.w500)),
          value: applyNewCalculations,
          onChanged: onApplyChanged, // Use the callback
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  // Helper widget specific to this section
  Widget _buildCalculationTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}