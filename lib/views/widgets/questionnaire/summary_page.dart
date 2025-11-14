import 'package:flutter/material.dart';
import '../../../utils/nutritional_calculator.dart'; // Import kalkulator
// Import widget SummaryTile
import 'summary_tile.dart';

class SummaryPage extends StatelessWidget {
  final Map<int, dynamic> answers;
  final VoidCallback onConfirm;

  const SummaryPage({
    super.key,
    required this.answers,
    required this.onConfirm,
  });

  String _getAnswerValue(int key, String unit, dynamic defaultValue) {
    final value = answers[key];
    if (value == null || (value is List && value.isEmpty)) {
      if (defaultValue is List && defaultValue.isEmpty) return 'Tidak ada';
      return '$defaultValue $unit'.trim();
    }
    if (value is List) {
      final filteredList = value.whereType<String>().where((item) => item.isNotEmpty).toList();
      if (filteredList.isEmpty) return 'Tidak ada';
      return filteredList.join(', ');
    }
    if (value is double) {
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} $unit'.trim();
    }
    if (value is int) {
      return '$value $unit'.trim();
    }
    return '$value $unit'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final gender = _getAnswerValue(0, '', 'Pria');
    final age = int.tryParse(_getAnswerValue(1, '', 24)) ?? 24;
    final height = int.tryParse(_getAnswerValue(2, '', 165)) ?? 165;
    final currentWeight = int.tryParse(_getAnswerValue(3, '', 50)) ?? 50;
    final goalWeight = int.tryParse(_getAnswerValue(4, '', 65)) ?? 65;
    final activityLevel = _getAnswerValue(5, '', 'Cukup Aktif');
    final goal = _getAnswerValue(6, '', 'Penurunan Berat Badan');
    final dietaryRestrictions = _getAnswerValue(7, '', []);
    final allergies = _getAnswerValue(8, '', []);

    final recommendations = NutritionalCalculator.calculateNeeds(
      gender: answers[0] ?? 'Pria',
      age: age,
      height: height,
      currentWeight: currentWeight,
      activityLevel: answers[5] ?? 'Cukup Aktif',
      goal: answers[6] ?? 'Penurunan Berat Badan',
    );

    final profileData = {
      "Jenis Kelamin": gender,
      "Usia": _getAnswerValue(1, ' tahun', 24),
      "Tinggi": _getAnswerValue(2, 'cm', 165),
      "Berat Saat Ini": _getAnswerValue(3, 'kg', 50),
      "Target Berat": _getAnswerValue(4, 'kg', 65),
      "Level Aktivitas": activityLevel,
      "Tujuan Diet": goal,
      "Pantangan Makan": dietaryRestrictions,
      "Alergi": allergies,
    };

    final recommendationTiles = {
      "Kalori Harian": "${recommendations['calories']} kkal",
      "Protein": "${recommendations['proteins']} g",
      "Lemak": "${recommendations['fats']} g",
      "Karbohidrat": "${recommendations['carbs']} g",
    };

    final bmiInfo = {
      "Indeks Massa Tubuh (IMT)": recommendations['bmi'] ?? 'N/A',
      "Kategori IMT": recommendations['bmiCategory'] ?? 'N/A',
    };

    return Container(
      color: Colors.grey[50],
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildSection(
                  title: "Ringkasan Profil",
                  data: profileData,
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: "Rekomendasi Harian",
                  data: recommendationTiles,
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: "Tinjauan IMT",
                  data: bmiInfo,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,-2))
                  ]
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                  ),
                  child: const Text(
                    'Mulai Pelacakan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Map<String, dynamic> data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInfoCard(
          children: data.entries.map((entry) {
            return SummaryTile(
              label: entry.key,
              value: entry.value,
              hasDivider: entry.key != data.keys.last,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(children: children),
      ),
    );
  }
}