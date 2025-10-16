import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/profile_controller.dart';
import '../widgets/question_widgets.dart';
import 'main_app_screen.dart';
import '../../utils/nutritional_calculator.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});
  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  final ProfileController _profileController = ProfileController();
  int _currentStep = 0;
  final int _totalSteps = 9;
  final Map<int, dynamic> _answers = {
    0: 'Pria',
    1: 24,
    2: 165,
    3: 65,
    4: 55,
    5: 'Cukup Aktif',
    6: 'Penurunan Berat Badan',
    7: [],
    8: [],
  };

  late final List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = [
      {'title': 'Jenis Kelamin Anda?', 'widget': SimpleGenderSelection(onChanged: (val) => _updateAnswer(0, val))},
      {'title': 'Berapa usiamu?', 'widget': _buildNumberPicker(1, "Masukkan usia Anda", 15, 80)},
      {'title': 'Berapa tinggi badanmu?', 'widget': _buildNumberPicker(2, "Masukkan tinggi badan Anda", 140, 220)},
      {'title': 'Berapa Berat Badan Anda Saat Ini?', 'widget': _buildNumberPicker(3, "Masukkan berat badan Anda", 40, 150)},
      {'title': 'Berapa berat target Anda?', 'widget': _buildNumberPicker(4, "Masukkan target berat badan Anda", 40, 150)},
      {
        'title': 'Seberapa aktif Anda?',
        'widget': ChoiceOptionsWithDescription(
          onChanged: (val) => _updateAnswer(5, val),
          options: const [
            {'title': 'Menetap', 'description': 'Sedikit atau tidak ada olahraga'},
            {'title': 'Ringan Aktif', 'description': 'Olahraga ringan atau olah raga 1-3 hari dalam seminggu'},
            {'title': 'Cukup Aktif', 'description': 'Olahraga sedang atau olah raga 3-5 hari seminggu'},
            {'title': 'Sangat Aktif', 'description': 'Olahraga berat atau olahraga 6-7 hari seminggu'},
            {'title': 'Sangat Aktif Sekali', 'description': 'Latihan atau olahraga yang sangat keras dan pekerjaan fisik'},
          ],
        ),
      },
      {
        'title': 'Apa tujuan diet Anda?',
        'widget': ChoiceOptionsWithDescription(
          onChanged: (val) => _updateAnswer(6, val),
          options: const [
            {'title': 'Penurunan Berat Badan', 'description': 'Turunkan berat badan secara bertahap dan berkelanjutan.'},
            {'title': 'Pertahankan Berat Badan', 'description': 'Pertahankan berat badan Anda saat ini dengan diet seimbang.'},
            {'title': 'Pertambahan Berat Badan', 'description': 'Tambah berat badan secara sehat dengan surplus kalori.'},
          ],
        ),
      },
      {
        'title': 'Preferensi Makanan Anda',
        'widget': ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Text('Beritahu kami tentang pantangan makanan dan alergi Anda.', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 30),
            MultiSelectCheckbox(
              title: 'Pembatasan Diet',
              options: const ['Vegetarian', 'Vegan', 'Halal'],
              onChanged: (selected) => _updateAnswer(7, selected),
            ),
            const SizedBox(height: 20),
            MultiSelectCheckbox(
              title: 'Alergi',
              options: const ['Perekat', 'Produk susu', 'Gula', 'Kedelai', 'Kerang'],
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

    if (currentAnswer == null) {
      isAnswerMissing = true;
    } else if (currentAnswer is String && currentAnswer.isEmpty) {
      isAnswerMissing = true;
    }

    if (_currentStep == 7 || _currentStep == 8) {
      isAnswerMissing = false;
    }

    if (isAnswerMissing) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap lengkapi data sebelum melanjutkan.')));
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _saveProfile();
    }
  }

  void _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sesi tidak valid.')));
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

    final updatedUser = await _profileController.saveProfileFromQuestionnaire(profileData, token);

    if (updatedUser != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainAppScreen(user: updatedUser)),
            (Route<dynamic> route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan profil.')));
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _updateAnswer(int step, dynamic answer) {
    setState(() => _answers[step] = answer);
    debugPrint("Step $step answered: ${_answers[step]}");
  }

  void _showPicker(int step, String title, int min, int max) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: CupertinoPicker(
            magnification: 1.2,
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(initialItem: (_answers[step] ?? min) - min),
            onSelectedItemChanged: (int selectedItem) {
              _updateAnswer(step, min + selectedItem);
            },
            children: List<Widget>.generate(max - min + 1, (int index) {
              return Center(child: Text('${min + index}'));
            }),
          ),
        );
      },
    );
  }

  Widget _buildNumberPicker(int step, String hint, int min, int max) {
    return DropdownNumberPicker(
      hintText: hint,
      value: _answers[step] ?? 0,
      onTap: () => _showPicker(step, hint, min, max),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLastStep = _currentStep == _totalSteps - 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isLastStep ? Colors.grey[50] : Colors.white,
        leading: _currentStep == 0 ? null : IconButton(icon: const Icon(Icons.arrow_back, size: 24, color: Colors.black54), onPressed: _previousPage),
        title: isLastStep ? const Text("Tinjauan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)) : null,
        actions: [
          if (!isLastStep)
            TextButton(
              onPressed: () {}, // Skip
              child: const Text('Lewati', style: TextStyle(color: Color(0xFF007BFF), fontSize: 16)),
            ),
          const SizedBox(width: 16),
        ],
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (!isLastStep)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _totalSteps,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF007BFF)),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _currentStep = page),
              itemCount: _totalSteps,
              itemBuilder: (context, index) {
                if (index < _questions.length) {
                  final question = _questions[index];
                  // === PERBAIKAN DI SINI ===
                  // Langsung gunakan widget yang sudah dibuat di initState
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

// ... Sisa kode (SummaryPage, SummaryTile) tetap sama ...

class SummaryPage extends StatelessWidget {
  final Map<int, dynamic> answers;
  final VoidCallback onConfirm;
  const SummaryPage({super.key, required this.answers, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final recommendations = NutritionalCalculator.calculateNeeds(
      gender: answers[0] as String? ?? 'Pria',
      age: answers[1] as int? ?? 24,
      height: answers[2] as int? ?? 165,
      currentWeight: answers[3] as int? ?? 65,
      activityLevel: answers[5] as String? ?? 'Cukup Aktif',
      goal: answers[6] as String? ?? 'Penurunan Berat Badan',
    );

    final recommendationTiles = {
      "Kalori": "${recommendations['calories']} kkal",
      "Protein": "${recommendations['proteins']} g",
      "Karbohidrat": "${recommendations['carbs']} g",
      "Lemak": "${recommendations['fats']} g",
      "IMT": "${recommendations['bmi']} (${recommendations['bmiCategory']})",
    };

    final dietaryRestrictions = (answers[7] as List<dynamic>?)?.join(', ');
    final allergies = (answers[8] as List<dynamic>?)?.join(', ');

    return Container(
      color: Colors.grey[50],
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ringkasan Profil", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoCard(
              children: [
                SummaryTile(label: "Jenis Kelamin", value: "${answers[0] ?? 'N/A'}"),
                SummaryTile(label: "Umur", value: "${answers[1] ?? 'N/A'}"),
                SummaryTile(label: "Tinggi", value: "${answers[2] ?? 'N/A'} cm"),
                SummaryTile(label: "Berat", value: "${answers[3] ?? 'N/A'} kg"),
                SummaryTile(label: "Target Berat", value: "${answers[4] ?? 'N/A'} kg"),
                SummaryTile(label: "Aktivitas", value: "${answers[5] ?? 'N/A'}"),
                SummaryTile(label: "Tujuan Diet", value: "${answers[6] ?? 'N/A'}"),
                SummaryTile(label: "Pembatasan Diet", value: (dietaryRestrictions == null || dietaryRestrictions.isEmpty) ? 'Tidak ada' : dietaryRestrictions),
                SummaryTile(label: "Alergi", value: (allergies == null || allergies.isEmpty) ? 'Tidak ada' : allergies, hasDivider: false),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Rekomendasi Harian", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoCard(
              children: recommendationTiles.entries.map((e) =>
                  SummaryTile(label: e.key, value: e.value, hasDivider: e.key != recommendationTiles.keys.last)
              ).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(0xFF007BFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                ),
                child: const Text('Mulai Pelacakan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
      ),
      child: Column(children: children),
    );
  }
}

class SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final bool hasDivider;
  const SummaryTile({super.key, required this.label, required this.value, this.hasDivider = true});

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
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                Flexible(
                  child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
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