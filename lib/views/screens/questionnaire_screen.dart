import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Sesuaikan path jika berbeda
import '../../controllers/profile_controller.dart';
import '../widgets/question_widgets.dart'; //
import 'main_app_screen.dart'; //
import '../../utils/nutritional_calculator.dart'; //
import '../../models/user_model.dart'; //

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});
  @override
  State<QuestionnaireScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  final ProfileController _profileController = ProfileController();
  int _currentStep = 0;
  // final int _totalQuestionSteps = 9; // Tidak terlalu perlu karena kita pakai _questions.length
  final Map<int, dynamic> _answers = {
    0: 'Pria', // Gender (Set default yang valid)
    1: 24, // Usia
    2: 165, // Tinggi
    3: 50, // Berat saat ini
    4: 65, // Target berat
    5: 'Cukup Aktif', // Level Aktivitas (Set default yang valid)
    6: 'Penurunan Berat Badan', // Tujuan diet (Set default yang valid)
    7: <String>[], // Pembatasan Diet (Gunakan list kosong)
    8: <String>[], // Alergi (Gunakan list kosong)
  };

  // --- PERUBAHAN 1: Definisikan _questions tanpa widget langsung ---
  // Kita akan definisikan tipe widget atau builder di sini
  late final List<Map<String, dynamic>> _questionDefinitions;

  @override
  void initState() {
    super.initState();

    // --- PERUBAHAN 1: Pindahkan definisi ke sini ---
    _questionDefinitions = [
      // Step 0: Jenis Kelamin
      {
        'title': 'Jenis Kelamin Anda?',
        'type': 'gender', // Tandai tipe widget
        // 'widget': SimpleGenderSelection(...) // Jangan buat widget di sini
      },
      // Step 1: Usia
      {
        'title': 'Berapa usiamu?',
        'type': 'picker', // Tandai tipe widget
        'min': 15,
        'max': 80,
        // 'widget': _buildInlineCupertinoPicker(1, 15, 80) // Jangan buat widget di sini
      },
      // Step 2: Tinggi Badan
      {
        'title': 'Berapa tinggi badanmu?',
        'type': 'picker',
        'min': 140,
        'max': 220,
      },
      // Step 3: Berat Badan Saat Ini
      {
        'title': 'Berapa Berat Badan Anda Saat Ini?',
        'type': 'picker',
        'min': 40,
        'max': 150,
      },
      // Step 4: Target Berat Badan
      {
        'title': 'Berapa berat target Anda?',
        'type': 'picker',
        'min': 40,
        'max': 150,
      },
      // Step 5: Level Aktivitas
      {
        'title': 'Seberapa aktif Anda?',
        'type': 'choice', // Tandai tipe widget
        'options': const [
          {'title': 'Menetap', 'description': 'Sedikit atau tidak ada olahraga'},
          {
            'title': 'Ringan Aktif',
            'description':
            'Olahraga ringan atau olah raga 1-3 hari dalam seminggu'
          },
          {
            'title': 'Cukup Aktif',
            'description': 'Olahraga sedang atau olah raga 3-5 hari seminggu'
          },
          {
            'title': 'Sangat Aktif',
            'description': 'Olahraga berat atau olahraga 6-7 hari seminggu'
          },
          {
            'title': 'Sangat Aktif Sekali',
            'description':
            'Latihan atau olahraga yang sangat keras dan pekerjaan fisik'
          },
        ],
      },
      // Step 6: Tujuan Diet
      {
        'title': 'Apa tujuan diet Anda?',
        'type': 'choice',
        'options': const [
          {
            'title': 'Penurunan Berat Badan',
            'description':
            'Turunkan berat badan secara bertahap dan berkelanjutan.'
          },
          {
            'title': 'Pertahankan Berat Badan',
            'description':
            'Pertahankan berat badan Anda saat ini dengan diet seimbang.'
          },
          {
            'title': 'Pertambahan Berat Badan',
            'description':
            'Tambah berat badan secara sehat dengan surplus kalori.'
          },
        ],
      },
      // Step 7: Pembatasan Diet
      {
        'title': 'Preferensi Makanan Anda',
        'type': 'multiselect', // Tandai tipe widget
        'description': 'Beritahu kami tentang pantangan makanan Anda.',
        'sectionTitle': 'Pembatasan Diet',
        'options': const [
          'Vegetarian',
          'Vegan',
          'Halal',
          'Keto',
          'Mediterania'
        ],
      },
      // Step 8: Alergi
      {
        'title': 'Preferensi Makanan Anda',
        'type': 'multiselect',
        'description': 'Beritahu kami tentang alergi makanan Anda.',
        'sectionTitle': 'Alergi',
        'options': const [
          'Perekat',
          'Produk susu',
          'Gula',
          'Kedelai',
          'Kerang',
          'Kacang'
        ],
      },
    ];
    // --- AKHIR PERUBAHAN 1 ---
  }

  void _onActionPressed() {
    // Logika validasi sudah cukup baik
    dynamic currentAnswer = _answers[_currentStep];
    bool isAnswerMissing = false;

    if (_currentStep <= 6) { // Cek jawaban wajib (misal sampai tujuan diet)
      if (currentAnswer == null ||
          (currentAnswer is String && currentAnswer.isEmpty) ||
          (currentAnswer is int && currentAnswer == 0 && _currentStep >= 1 && _currentStep <= 4 ) ) { // Angka 0 tidak valid untuk usia, tinggi, berat
        isAnswerMissing = true;
      }
    }
    // Anggap multiselect tidak wajib diisi

    if (isAnswerMissing) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap lengkapi data sebelum melanjutkan.')));
      return;
    }

    // Navigasi ke halaman berikutnya
    if (_currentStep < _questionDefinitions.length) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _saveProfile() async {
    // Fungsi ini sudah OK
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sesi tidak valid.')));
      }
      return;
    }

    // Pastikan goals dikirim sebagai list (sesuai model backend jika diperlukan)
    final goalsList = _answers[6] is String && (_answers[6] as String).isNotEmpty
        ? [_answers[6]]
        : <String>[];


    final Map<String, dynamic> profileData = {
      'gender': _answers[0],
      'age': _answers[1],
      'height': _answers[2],
      'currentWeight': _answers[3],
      'goalWeight': _answers[4],
      'activityLevel': _answers[5],
      'goals': goalsList, // Kirim sebagai list
      'dietaryRestrictions': _answers[7] ?? [],
      'allergies': _answers[8] ?? [],
    };

    final updatedUser =
    await _profileController.saveProfileFromQuestionnaire(profileData, token);

    if (updatedUser != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainAppScreen(user: updatedUser)),
            (Route<dynamic> route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Gagal menyimpan profil.')));
    }
  }

  void _previousPage() {
    // Fungsi ini sudah OK
    if (_currentStep > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _updateAnswer(int step, dynamic answer) {
    // Fungsi ini sudah OK
    setState(() => _answers[step] = answer);
    print("Updated _answers[$step]: ${_answers[step]}");
  }


  // Widget untuk CupertinoPicker (sudah OK)
  // Fungsi ini akan dipanggil dari itemBuilder PageView
  Widget _buildInlineCupertinoPicker(int step, int min, int max) {
    int initialValue = (_answers[step] is int ? _answers[step] : min) as int;
    int calculatedInitialItem = initialValue - min;
    // Pastikan initial item tidak negatif atau melebihi batas
    calculatedInitialItem = calculatedInitialItem.clamp(0, max - min);

    print("Building picker for step $step. initialValue: $initialValue, calculatedInitialItem: $calculatedInitialItem");

    return SizedBox(
      height: 150,
      child: CupertinoPicker(
        magnification: 1.2,
        itemExtent: 32.0,
        scrollController: FixedExtentScrollController(
            initialItem: calculatedInitialItem), // Gunakan nilai yang sudah dihitung & divalidasi
        onSelectedItemChanged: (int index) {
          _updateAnswer(step, min + index);
        },
        children: List<Widget>.generate(max - min + 1, (int index) {
          return Center(child: Text('${min + index}'));
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah halaman summary
    bool isSummaryPage = _currentStep == _questionDefinitions.length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isSummaryPage ? Colors.grey[50] : Colors.white,
        leading: _currentStep == 0
            ? null
            : IconButton(
            icon: const Icon(Icons.arrow_back, size: 24, color: Colors.black54),
            onPressed: _previousPage),
        title: isSummaryPage
            ? const Text("Tinjauan",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87))
            : null,
        actions: [
          if (!isSummaryPage)
            TextButton(
              onPressed: () => _pageController.jumpToPage(_questionDefinitions.length), // Langsung ke summary
              child: const Text('Lewati',
                  style: TextStyle(color: Color(0xFF007BFF), fontSize: 16)),
            ),
          const SizedBox(width: 16),
        ],
        centerTitle: true,
      ),
      backgroundColor: isSummaryPage ? Colors.grey[50] : Colors.white,
      body: Column(
        children: [
          // Progress Bar
          if (!isSummaryPage)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _questionDefinitions.length, // Gunakan length dari definitions
                backgroundColor: Colors.grey[200],
                valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF007BFF)),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          // PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _currentStep = page),
              itemCount: _questionDefinitions.length + 1, // Tambah 1 untuk summary
              itemBuilder: (context, index) {
                // --- PERUBAHAN 2: Bangun widget di dalam itemBuilder ---
                if (index < _questionDefinitions.length) {
                  final definition = _questionDefinitions[index];
                  Widget questionWidget;

                  // Tentukan widget berdasarkan 'type'
                  switch (definition['type']) {
                    case 'gender':
                      questionWidget = SimpleGenderSelection(
                        onChanged: (val) => _updateAnswer(index, val),
                        initialValue: _answers[index],
                      );
                      break;
                    case 'picker':
                      questionWidget = _buildInlineCupertinoPicker(
                        index,
                        definition['min'],
                        definition['max'],
                      );
                      break;
                    case 'choice':
                      questionWidget = ChoiceOptionsWithDescription(
                        onChanged: (val) => _updateAnswer(index, val),
                        initialValue: _answers[index],
                        options: definition['options'],
                      );
                      break;
                    case 'multiselect':
                      questionWidget = MultiSelectSection(
                        description: definition['description'],
                        initialSelected: _answers[index] as List<String>,
                        sections: [
                          MultiSelectCheckbox(
                            title: definition['sectionTitle'],
                            options: definition['options'],
                            initialSelected: _answers[index] as List<String>,
                            onChanged: (selected) => _updateAnswer(index, selected),
                          ),
                        ],
                      );
                      break;
                    default:
                      questionWidget = const Text('Tipe widget tidak dikenal'); // Fallback
                  }

                  // Kembalikan QuestionPageContent dengan widget yang baru dibuat
                  return QuestionPageContent(
                    title: definition['title'],
                    onContinue: _onActionPressed,
                    onBack: _previousPage,
                    child: questionWidget, // Gunakan widget yang baru dibuat
                  );
                } else {
                  // Halaman Summary
                  return SummaryPage(answers: _answers, onConfirm: _saveProfile);
                }
                // --- AKHIR PERUBAHAN 2 ---
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// Summary Page Widget & Summary Tile (Sudah OK, tidak perlu diubah lagi dari kode sebelumnya)
// =========================================================================
class SummaryPage extends StatelessWidget {
  final Map<int, dynamic> answers;
  final VoidCallback onConfirm;
  const SummaryPage({super.key, required this.answers, required this.onConfirm});

  String _getAnswerValue(int key, String unit, dynamic defaultValue) {
    final value = answers[key];
    if (value == null) {
      // Jika nilai null, coba gunakan defaultValue
      if (defaultValue is List && defaultValue.isEmpty) return 'Tidak ada';
      return '$defaultValue $unit'.trim();
    }

    if (value is List) {
      final filteredList = value.where((item) => item is String && item.isNotEmpty).toList();
      if (filteredList.isEmpty) return 'Tidak ada';
      return filteredList.join(', ');
    }
    // Pastikan nilai integer/double tidak menampilkan desimal jika tidak perlu
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
    final gender = answers[0] as String? ?? 'Pria';
    final age = answers[1] as int? ?? 24;
    final height = answers[2] as int? ?? 165;
    final currentWeight = answers[3] as int? ?? 50; // Sesuaikan default jika perlu
    final goalWeight = answers[4] as int? ?? 65; // Sesuaikan default jika perlu
    final activityLevel = answers[5] as String? ?? 'Cukup Aktif';
    final goal = answers[6] as String? ?? 'Penurunan Berat Badan';
    final dietaryRestrictions = answers[7] as List<dynamic>? ?? [];
    final allergies = answers[8] as List<dynamic>? ?? [];


    // Kalkulasi Rekomendasi
    final recommendations = NutritionalCalculator.calculateNeeds(
      gender: gender,
      age: age,
      height: height,
      currentWeight: currentWeight,
      activityLevel: activityLevel,
      goal: goal,
    );

    // Data Profil untuk ditampilkan
    final profileData = {
      "Jenis Kelamin": _getAnswerValue(0, '', 'Pria'),
      "Umur": _getAnswerValue(1, '', 24),
      "Tinggi": _getAnswerValue(2, 'cm', 165),
      "Berat": _getAnswerValue(3, 'kg', 50),
      "Target Berat": _getAnswerValue(4, 'kg', 65),
      "Level Aktifitas": _getAnswerValue(5, '', 'Cukup Aktif'),
      "Tujuan Diet": _getAnswerValue(6, '', 'Penurunan Berat Badan'),
      "Pembatasan Diet": _getAnswerValue(7, '', []), // Default list kosong
      "Alergi": _getAnswerValue(8, '', []), // Default list kosong
    };

    // Data Rekomendasi
    final recommendationTiles = {
      "Kalori": "${recommendations['calories']} kkal",
      "Protein": "${recommendations['proteins']} g",
      "Lemak": "${recommendations['fats']} g",
      "Karbohidrat": "${recommendations['carbs']} g",
    };

    // Data BMI
    final bmiInfo = {
      "IMT": recommendations['bmi'] as String? ?? 'N/A',
      "Kategori IMT": recommendations['bmiCategory'] as String? ?? 'N/A',
    };

    // Layout Halaman Summary (Sudah OK)
    return Container(
      color: Colors.grey[50],
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 120), // Padding bawah untuk tombol
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text("Ringkasan Profil",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildInfoCard(
                  children: profileData.entries.map((entry) {
                    return SummaryTile(
                      label: entry.key,
                      value: entry.value,
                      hasDivider: entry.key != profileData.keys.last,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text("Rekomendasi Harian",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildInfoCard(
                  children: recommendationTiles.entries.map((entry) {
                    return SummaryTile(
                      label: entry.key,
                      value: entry.value,
                      hasDivider: entry.key != recommendationTiles.keys.last,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text("Tinjauan IMT",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildInfoCard(
                  children: bmiInfo.entries.map((entry) {
                    return SummaryTile(
                      label: entry.key,
                      value: entry.value,
                      hasDivider: entry.key != bmiInfo.keys.last,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20), // Padding tambahan di bawah
              ],
            ),
          ),
          // Tombol Konfirmasi di bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                  color: Colors.grey[50]?.withOpacity(0.95), // Background semi-transparan
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0,-2)) // Shadow ke atas
                  ]
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onConfirm, // Panggil fungsi _saveProfile
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: const Color(0xFF007BFF), // Warna biru
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)), // Tombol rounded
                  ),
                  child: const Text('Mulai Pelacakan',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget Info Card (Sudah OK)
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
      child: Column(children: children),
    );
  }
}

// Widget Summary Tile (Sudah OK)
class SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final bool hasDivider;

  const SummaryTile({
    super.key,
    required this.label,
    required this.value,
    this.hasDivider = true, // Defaultnya ada divider
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding horizontal
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding vertikal
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Label kiri, value kanan
              children: [
                // Label
                Text(label,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                // Value (Fleksibel agar tidak overflow)
                Flexible(
                  child: Text(value,
                      textAlign: TextAlign.right, // Rata kanan
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87)),
                ),
              ],
            ),
          ),
          // Tampilkan divider jika hasDivider true
          if (hasDivider) Divider(height: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }
}