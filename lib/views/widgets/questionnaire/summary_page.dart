import 'package:flutter/material.dart';
import '../../../utils/nutritional_calculator.dart'; // Import kalkulator
// Import widget SummaryTile
import 'summary_tile.dart';

// Widget untuk menampilkan halaman ringkasan kuesioner
class SummaryPage extends StatelessWidget {
  final Map<int, dynamic> answers; // Data jawaban dari kuesioner
  final VoidCallback onConfirm; // Callback saat tombol konfirmasi ditekan

  const SummaryPage({
    super.key,
    required this.answers,
    required this.onConfirm,
  });

  // Helper untuk mendapatkan dan memformat nilai jawaban
  String _getAnswerValue(int key, String unit, dynamic defaultValue) {
    final value = answers[key];
    if (value == null || (value is List && value.isEmpty)) {
      if (defaultValue is List && defaultValue.isEmpty) return 'Tidak ada';
      return '$defaultValue $unit'.trim();
    }
    if (value is List) {
      // Filter list string yang valid
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
    // Ambil nilai dengan default yang lebih aman
    final gender = _getAnswerValue(0, '', 'Pria');
    final age = int.tryParse(_getAnswerValue(1, '', 24)) ?? 24; // Pastikan int
    final height = int.tryParse(_getAnswerValue(2, '', 165)) ?? 165; // Pastikan int
    final currentWeight = int.tryParse(_getAnswerValue(3, '', 50)) ?? 50; // Pastikan int
    final goalWeight = int.tryParse(_getAnswerValue(4, '', 65)) ?? 65; // Pastikan int
    final activityLevel = _getAnswerValue(5, '', 'Cukup Aktif');
    final goal = _getAnswerValue(6, '', 'Penurunan Berat Badan');
    final dietaryRestrictions = _getAnswerValue(7, '', []);
    final allergies = _getAnswerValue(8, '', []);

    // Kalkulasi Rekomendasi
    final recommendations = NutritionalCalculator.calculateNeeds(
      gender: answers[0] ?? 'Pria', // Gunakan nilai asli untuk kalkulasi
      age: age,
      height: height,
      currentWeight: currentWeight,
      activityLevel: answers[5] ?? 'Cukup Aktif',
      goal: answers[6] ?? 'Penurunan Berat Badan',
    );

    // Data Profil untuk ditampilkan
    final profileData = {
      "Jenis Kelamin": gender,
      "Usia": _getAnswerValue(1, ' tahun', 24), // Tambah 'tahun'
      "Tinggi": _getAnswerValue(2, 'cm', 165),
      "Berat Saat Ini": _getAnswerValue(3, 'kg', 50),
      "Target Berat": _getAnswerValue(4, 'kg', 65),
      "Level Aktivitas": activityLevel,
      "Tujuan Diet": goal,
      "Pantangan Makan": dietaryRestrictions,
      "Alergi": allergies,
    };

    // Data Rekomendasi
    final recommendationTiles = {
      "Kalori Harian": "${recommendations['calories']} kkal",
      "Protein": "${recommendations['proteins']} g",
      "Lemak": "${recommendations['fats']} g",
      "Karbohidrat": "${recommendations['carbs']} g",
    };

    // Data BMI
    final bmiInfo = {
      "Indeks Massa Tubuh (IMT)": recommendations['bmi'] ?? 'N/A',
      "Kategori IMT": recommendations['bmiCategory'] ?? 'N/A',
    };

    // Layout Halaman Summary
    return Container(
      color: Colors.grey[50], // Background abu-abu muda
      child: Stack( // Gunakan Stack agar tombol bisa mengambang
        children: [
          // Konten yang bisa di-scroll
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            // Padding bawah untuk memberi ruang tombol mengambang
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Section Ringkasan Profil
                _buildSection(
                  title: "Ringkasan Profil",
                  data: profileData,
                ),
                const SizedBox(height: 24),
                // Section Rekomendasi Harian
                _buildSection(
                  title: "Rekomendasi Harian",
                  data: recommendationTiles,
                ),
                const SizedBox(height: 24),
                // Section Tinjauan IMT
                _buildSection(
                  title: "Tinjauan IMT",
                  data: bmiInfo,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Tombol Konfirmasi di bawah (mengambang)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                // Background sedikit transparan agar konten di belakangnya samar terlihat
                  color: Colors.white.withOpacity(0.95),
                  // Shadow ke atas
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,-2))
                  ]
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onConfirm, // Gunakan callback onConfirm
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Theme.of(context).primaryColor, // Warna primer
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)), // Tombol rounded
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

  // Helper widget untuk membuat satu section (judul + kartu)
  Widget _buildSection({required String title, required Map<String, dynamic> data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInfoCard( // Gunakan helper kartu
          children: data.entries.map((entry) {
            return SummaryTile( // Gunakan SummaryTile
              label: entry.key,
              value: entry.value,
              hasDivider: entry.key != data.keys.last, // Divider kecuali item terakhir
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper widget untuk membuat kartu informasi
  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5)) // Shadow tipis
        ],
      ),
      child: ClipRRect( // Clip agar divider tidak keluar dari border radius
        borderRadius: BorderRadius.circular(16),
        child: Column(children: children),
      ),
    );
  }
}