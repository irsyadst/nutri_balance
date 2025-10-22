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
  final int _totalQuestionSteps = 9; // Hanya jumlah pertanyaan
  final Map<int, dynamic> _answers = {
    0: '', // Gender
    1: 24, // Usia
    2: 165, // Tinggi
    3: 50, // Berat saat ini
    4: 65, // Target berat
    5: '', // Level Aktivitas
    6: '', // Tujuan diet
    7: [''], // Pembatasan Diet (default)
    8: [''], // Alergi (default)
  };

  late final List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = [
      // Step 0: Jenis Kelamin
      {
        'title': 'Jenis Kelamin Anda?',
        'widget': SimpleGenderSelection(
            onChanged: (val) => _updateAnswer(0, val),
            initialValue: _answers[0])
      },
      // Step 1: Usia
      {
        'title': 'Berapa usiamu?',
        // --- PERUBAHAN DI SINI ---
        'widget': _buildInlineCupertinoPicker(1, 15, 80)
      },
      // Step 2: Tinggi Badan
      {
        'title': 'Berapa tinggi badanmu?',
        // --- PERUBAHAN DI SINI ---
        'widget': _buildInlineCupertinoPicker(2, 140, 220)
      },
      // Step 3: Berat Badan Saat Ini
      {
        'title': 'Berapa Berat Badan Anda Saat Ini?',
        // --- PERUBAHAN DI SINI ---
        'widget': _buildInlineCupertinoPicker(3, 40, 150)
      },
      // Step 4: Target Berat Badan
      {
        'title': 'Berapa berat target Anda?',
        // --- PERUBAHAN DI SINI ---
        'widget': _buildInlineCupertinoPicker(4, 40, 150)
      },
      // Step 5: Level Aktivitas
      {
        'title': 'Seberapa aktif Anda?',
        'widget': ChoiceOptionsWithDescription(
          onChanged: (val) => _updateAnswer(5, val),
          initialValue: _answers[5],
          options: const [
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
        ),
      },
      // Step 6: Tujuan Diet
      {
        'title': 'Apa tujuan diet Anda?',
        'widget': ChoiceOptionsWithDescription(
          onChanged: (val) => _updateAnswer(6, val),
          initialValue: _answers[6],
          options: const [
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
        ),
      },
      // Step 7: Pembatasan Diet
      {
        'title': 'Preferensi Makanan Anda',
        'widget': MultiSelectSection(
          description: 'Beritahu kami tentang pantangan makanan Anda.',
          initialSelected: _answers[7] as List<String>? ?? [], // Null check
          sections: [
            MultiSelectCheckbox(
              title: 'Pembatasan Diet',
              options: const [
                'Vegetarian',
                'Vegan',
                'Halal',
                'Keto',
                'Mediterania'
              ],
              initialSelected: _answers[7] as List<String>? ?? [], // Null check
              onChanged: (selected) => _updateAnswer(7, selected),
            ),
          ],
        ),
      },
      // Step 8: Alergi
      {
        'title': 'Preferensi Makanan Anda',
        'widget': MultiSelectSection(
          description: 'Beritahu kami tentang alergi makanan Anda.',
          initialSelected: _answers[8] as List<String>? ?? [], // Null check
          sections: [
            MultiSelectCheckbox(
              title: 'Alergi',
              options: const [
                'Perekat',
                'Produk susu',
                'Gula',
                'Kedelai',
                'Kerang',
                'Kacang'
              ],
              initialSelected: _answers[8] as List<String>? ?? [], // Null check
              onChanged: (selected) => _updateAnswer(8, selected),
            ),
          ],
        ),
      },
    ];
  }

  void _onActionPressed() {
    dynamic currentAnswer = _answers[_currentStep];
    bool isAnswerMissing = false;

    if (_currentStep < 7) {
      if (currentAnswer == null ||
          (currentAnswer is String && currentAnswer.isEmpty) ||
          (currentAnswer is int && currentAnswer == 0 && _currentStep > 0) ) {
        isAnswerMissing = true;
      }
    }

    if (isAnswerMissing) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap lengkapi data sebelum melanjutkan.')));
      return;
    }

    _pageController.nextPage(
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  void _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sesi tidak valid.')));
      }
      return;
    }

    final Map<String, dynamic> profileData = {
      'gender': _answers[0],
      'age': _answers[1],
      'height': _answers[2],
      'currentWeight': _answers[3],
      'goalWeight': _answers[4],
      'activityLevel': _answers[5],
      'goals': [_answers[6]],
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
    if (_currentStep > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _updateAnswer(int step, dynamic answer) {
    setState(() => _answers[step] = answer);
    debugPrint("Step $step answered: ${_answers[step]}");
  }

  // --- HAPUS FUNGSI _showPicker ---
  /*
  void _showPicker(int step, String title, int min, int max) {
    // ... (kode lama dihapus) ...
  }
  */

  // --- UBAH FUNGSI INI menjadi _buildInlineCupertinoPicker ---
  Widget _buildInlineCupertinoPicker(int step, int min, int max) {
    int initialValue = (_answers[step] is int ? _answers[step] : min) as int;
    return SizedBox( // Beri batasan tinggi untuk picker
      height: 150, // Sesuaikan tinggi sesuai kebutuhan desain
      child: CupertinoPicker(
        magnification: 1.2,
        itemExtent: 32.0, // Tinggi setiap item
        scrollController: FixedExtentScrollController(
            initialItem: initialValue - min), // Set posisi awal
        onSelectedItemChanged: (int index) {
          // LANGSUNG update state saat nilai berubah
          _updateAnswer(step, min + index);
        },
        children: List<Widget>.generate(max - min + 1, (int index) {
          return Center(child: Text('${min + index}'));
        }),
      ),
    );
  }

  // --- HAPUS FUNGSI _buildNumberPicker ---
  /*
  Widget _buildNumberPicker(int step, String hint, int min, int max) {
    int displayValue = _answers[step] ?? min;
    return DropdownNumberPicker(
      key: ValueKey('picker_$step\_$displayValue'),
      hintText: hint,
      value: displayValue,
      onTap: () => _showPicker(step, hint, min, max),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    bool isSummaryPage = _currentStep == _questions.length;

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
              onPressed: () => _pageController.jumpToPage(_questions.length),
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
          if (!isSummaryPage)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _questions.length,
                backgroundColor: Colors.grey[200],
                valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF007BFF)),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _currentStep = page),
              itemCount: _questions.length + 1,
              itemBuilder: (context, index) {
                if (index < _questions.length) {
                  final question = _questions[index];
                  return QuestionPageContent(
                    title: question['title'],
                    onContinue: _onActionPressed,
                    onBack: _previousPage,
                    child: question['widget'],
                  );
                } else {
                  return SummaryPage(answers: _answers, onConfirm: _saveProfile);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// Summary Page Widget & Summary Tile (Tidak perlu diubah)
// =========================================================================
class SummaryPage extends StatelessWidget {
  final Map<int, dynamic> answers;
  final VoidCallback onConfirm;
  const SummaryPage({super.key, required this.answers, required this.onConfirm});

  String _getAnswerValue(int key, String unit, dynamic defaultValue) {
    final value = answers[key] ?? defaultValue;
    if (value is List) {
      return value.isEmpty ? 'Tidak ada' : value.join(', ');
    }
    return '$value $unit'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final gender = answers[0] as String? ?? 'Pria';
    final age = answers[1] as int? ?? 24;
    final height = answers[2] as int? ?? 165;
    final currentWeight = answers[3] as int? ?? 65;
    final activityLevel = answers[5] as String? ?? 'Cukup Aktif';
    final goal = answers[6] as String? ?? 'Penurunan Berat Badan';

    final recommendations = NutritionalCalculator.calculateNeeds(
      gender: gender,
      age: age,
      height: height,
      currentWeight: currentWeight,
      activityLevel: activityLevel,
      goal: goal,
    );

    final profileData = {
      "Jenis Kelamin": _getAnswerValue(0, '', 'N/A'),
      "Umur": _getAnswerValue(1, '', 'N/A'),
      "Tinggi": _getAnswerValue(2, 'cm', 'N/A'),
      "Berat": _getAnswerValue(3, 'kg', 'N/A'),
      "Target Berat": _getAnswerValue(4, 'kg', 'N/A'),
      "Level Aktifitas": _getAnswerValue(5, '', 'N/A'),
      "Tujuan Diet": _getAnswerValue(6, '', 'N/A'),
      "Pembatasan Diet": _getAnswerValue(7, '', []),
      "Alergi": _getAnswerValue(8, '', []),
    };

    final recommendationTiles = {
      "Kalori": "${recommendations['calories']} kkal",
      "Protein": "${recommendations['proteins']} g",
      "Lemak": "${recommendations['fats']} g",
      "Karbohidrat": "${recommendations['carbs']} g",
    };

    final bmiInfo = {
      "IMT": recommendations['bmi'] as String? ?? 'N/A',
      "Kategori IMT": recommendations['bmiCategory'] as String? ?? 'N/A',
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
                const Text("Ringkasan Profil",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildInfoCard(
                  children: [
                    SummaryTile(label: "Jenis Kelamin", value: profileData["Jenis Kelamin"]!),
                    SummaryTile(label: "Umur", value: profileData["Umur"]!),
                    SummaryTile(label: "Tinggi", value: profileData["Tinggi"]!),
                    SummaryTile(label: "Berat", value: profileData["Berat"]!),
                    SummaryTile(label: "Target Berat", value: profileData["Target Berat"]!),
                    SummaryTile(label: "Level Aktifitas", value: profileData["Level Aktifitas"]!),
                    SummaryTile(label: "Tujuan Diet", value: profileData["Tujuan Diet"]!),
                    SummaryTile(label: "Pembatasan Diet", value: profileData["Pembatasan Diet"]!),
                    SummaryTile(label: "Alergi", value: profileData["Alergi"]!, hasDivider: false),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("Rekomendasi Harian",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildInfoCard(
                  children: [
                    SummaryTile(label: "Kalori", value: recommendationTiles["Kalori"]!),
                    SummaryTile(label: "Protein", value: recommendationTiles["Protein"]!),
                    SummaryTile(label: "Karbohidrat", value: recommendationTiles["Karbohidrat"]!),
                    SummaryTile(label: "Lemak", value: recommendationTiles["Lemak"]!, hasDivider: false),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("Tinjauan IMT",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildInfoCard(
                  children: [
                    SummaryTile(label: "IMT", value: bmiInfo["IMT"]!),
                    SummaryTile(label: "Kategori", value: bmiInfo["Kategori IMT"]!, hasDivider: false),
                  ],
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
                  color: Colors.grey[50]?.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0,-2))
                  ]
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: const Color(0xFF007BFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
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
      child: Column(children: children),
    );
  }

  String _mapDietToPreference(List<dynamic>? restrictions) {
    if (restrictions == null || restrictions.isEmpty) return 'Bebas';
    return restrictions.map((e) => e.toString()).join(', ');
  }

}

class SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final bool hasDivider;

  const SummaryTile({
    super.key,
    required this.label,
    required this.value,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                Flexible(
                  child: Text(value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87)),
                ),
              ],
            ),
          ),
          if (hasDivider) Divider(height: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }
}