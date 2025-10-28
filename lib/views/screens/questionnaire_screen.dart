import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/profile_controller.dart';
// Import widget dari file terpisah
import '../widgets/questionnaire/question_widgets.dart'; // Widget pertanyaan generik
import '../widgets/questionnaire/summary_page.dart'; // Widget halaman ringkasan
import 'main_app_screen.dart';
import '../../utils/nutritional_calculator.dart';
import '../../models/user_model.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});
  @override
  State<QuestionnaireScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  final ProfileController _profileController = ProfileController();
  int _currentStep = 0;
  final Map<int, dynamic> _answers = {
    0: 'Pria',          // Default Gender
    1: 24,              // Default Usia
    2: 165,             // Default Tinggi
    3: 50,              // Default Berat saat ini
    4: 65,              // Default Target berat
    5: 'Cukup Aktif',   // Default Level Aktivitas
    6: 'Penurunan Berat Badan', // Default Tujuan diet
    7: <String>[],      // Default Pembatasan Diet
    8: <String>[],      // Default Alergi
  };

  late final List<Map<String, dynamic>> _questionDefinitions; // Definisi pertanyaan

  @override
  void initState() {
    super.initState();

    // Definisi pertanyaan (tetap di initState)
    _questionDefinitions = [
      {'title': 'Jenis Kelamin Anda?', 'type': 'gender'},
      {'title': 'Berapa usiamu?', 'type': 'picker', 'min': 15, 'max': 80},
      {'title': 'Berapa tinggi badanmu (cm)?', 'type': 'picker', 'min': 140, 'max': 220}, // Tambah (cm)
      {'title': 'Berat Badan Saat Ini (kg)?', 'type': 'picker', 'min': 40, 'max': 150}, // Tambah (kg)
      {'title': 'Target Berat Badan (kg)?', 'type': 'picker', 'min': 40, 'max': 150}, // Tambah (kg)
      {'title': 'Seberapa aktif Anda?', 'type': 'choice', 'options': _activityLevelOptions},
      {'title': 'Apa tujuan diet Anda?', 'type': 'choice', 'options': _dietGoalOptions},
      {'title': 'Preferensi Makanan Anda', 'type': 'multiselect', 'description': 'Beritahu kami tentang pantangan makanan Anda.', 'sectionTitle': 'Pantangan Makan', 'options': _dietaryRestrictionOptions},
      {'title': 'Preferensi Makanan Anda', 'type': 'multiselect', 'description': 'Beritahu kami tentang alergi makanan Anda.', 'sectionTitle': 'Alergi', 'options': _allergyOptions},
    ];
    // Pastikan _answers diinisialisasi dengan benar (sudah di atas)
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureInitialAnswersValid());
  }

  // Pastikan jawaban awal diteruskan ke widget yang membutuhkannya
  void _ensureInitialAnswersValid() {
    _questionDefinitions.asMap().forEach((index, definition) {
      switch (definition['type']) {
        case 'gender':
        case 'choice':
        case 'multiselect':
          _updateAnswer(index, _answers[index]); // Panggil updateAnswer untuk trigger onChanged awal
          break;
      // Picker tidak perlu karena nilainya diambil saat picker dibangun
      }
    });
  }


  @override
  void dispose() { // Jangan lupa dispose controller
    _pageController.dispose();
    super.dispose();
  }

  // --- Opsi Pilihan (dibuat sebagai konstanta) ---
  static const List<Map<String, String>> _activityLevelOptions = [
    {'title': 'Menetap', 'description': 'Sedikit atau tidak ada olahraga'},
    {'title': 'Ringan Aktif', 'description': 'Olahraga ringan 1-3 hari/minggu'},
    {'title': 'Cukup Aktif', 'description': 'Olahraga sedang 3-5 hari/minggu'},
    {'title': 'Sangat Aktif', 'description': 'Olahraga berat 6-7 hari/minggu'},
    {'title': 'Sangat Aktif Sekali', 'description': 'Pekerjaan fisik/olahraga berat'},
  ];
  static const List<Map<String, String>> _dietGoalOptions = [
    {'title': 'Penurunan Berat Badan', 'description': 'Turunkan berat badan secara bertahap.'},
    {'title': 'Pertahankan Berat Badan', 'description': 'Pertahankan berat badan saat ini.'},
    {'title': 'Pertambahan Berat Badan', 'description': 'Tambah berat badan secara sehat.'},
  ];
  static const List<String> _dietaryRestrictionOptions = ['Vegetarian', 'Vegan', 'Halal', 'Keto', 'Mediterania'];
  static const List<String> _allergyOptions = ['Gluten', 'Susu', 'Gula', 'Kedelai', 'Kerang', 'Kacang'];


  void _onActionPressed() {
    // Navigasi ke halaman berikutnya
    if (_currentStep < _questionDefinitions.length) { // Pergi ke summary jika ini langkah terakhir
      _pageController.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
    // Tidak ada validasi di sini karena tombol 'Selanjutnya' selalu aktif
  }

  void _saveProfile() async {
    // Fungsi ini sudah OK
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) { /* ... handle error ... */ return; }

    // Pastikan goals dikirim sebagai list
    final goalsList = _answers[6] is String && (_answers[6] as String).isNotEmpty ? [_answers[6]] : <String>[];

    final Map<String, dynamic> profileData = {
      'gender': _answers[0], 'age': _answers[1], 'height': _answers[2],
      'currentWeight': _answers[3], 'goalWeight': _answers[4], 'activityLevel': _answers[5],
      'goals': goalsList,
      'dietaryRestrictions': _answers[7] ?? [],
      'allergies': _answers[8] ?? [],
    };

    final updatedUser = await _profileController.saveProfileFromQuestionnaire(profileData, token);

    if (updatedUser != null && mounted) {
      Navigator.pushAndRemoveUntil( context, MaterialPageRoute(builder: (context) => MainAppScreen(user: updatedUser)), (Route<dynamic> route) => false, );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan profil.')));
    }
  }

  void _previousPage() {
    // Kembali ke halaman sebelumnya atau keluar jika di halaman pertama
    if (_currentStep > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pop(); // Keluar dari QuestionnaireScreen
    }
  }

  void _updateAnswer(int step, dynamic answer) {
    // Update state jawaban
    setState(() => _answers[step] = answer);
    print("Updated _answers[$step]: ${_answers[step]}");
  }

  // Widget untuk CupertinoPicker (Tetap di sini karena terkait state)
  Widget _buildInlineCupertinoPicker(int step, int min, int max) {
    int initialValue = (_answers[step] as int?) ?? min; // Ambil nilai atau default
    // Pastikan initial item valid
    int calculatedInitialItem = (initialValue - min).clamp(0, max - min);

    return SizedBox(
      height: 150,
      child: CupertinoPicker(
        magnification: 1.2,
        itemExtent: 32.0,
        scrollController: FixedExtentScrollController(initialItem: calculatedInitialItem),
        onSelectedItemChanged: (int index) => _updateAnswer(step, min + index), // Update state saat berubah
        children: List<Widget>.generate(max - min + 1, (int index) {
          return Center(child: Text('${min + index}'));
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan apakah sedang di halaman summary
    bool isSummaryPage = _currentStep == _questionDefinitions.length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isSummaryPage ? Colors.grey[50] : Colors.white,
        leading: IconButton( // Tombol back selalu ada
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.grey[600]), // Ikon lebih kecil & abu
            onPressed: _previousPage),
        title: isSummaryPage // Judul hanya tampil di halaman summary
            ? const Text("Ringkasan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87))
            : null,
        actions: [
          // Tombol Lewati hanya jika BUKAN halaman summary
          if (!isSummaryPage)
            TextButton(
              onPressed: () => _pageController.jumpToPage(_questionDefinitions.length), // Langsung ke summary
              child: Text('Lewati', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
            ),
          const SizedBox(width: 16),
        ],
        centerTitle: true,
      ),
      backgroundColor: isSummaryPage ? Colors.grey[50] : Colors.white, // Background berbeda
      body: Column(
        children: [
          // Progress Bar (hanya jika BUKAN halaman summary)
          if (!isSummaryPage)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _questionDefinitions.length,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          // PageView untuk pertanyaan dan summary
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Nonaktifkan swipe manual
              onPageChanged: (page) => setState(() => _currentStep = page),
              itemCount: _questionDefinitions.length + 1, // Jumlah pertanyaan + 1 summary
              itemBuilder: (context, index) {
                // Jika index adalah halaman summary
                if (index == _questionDefinitions.length) {
                  // Gunakan widget SummaryPage yang sudah dipisah
                  return SummaryPage(answers: _answers, onConfirm: _saveProfile);
                }
                // Jika index adalah halaman pertanyaan
                else {
                  final definition = _questionDefinitions[index];
                  Widget questionWidget;

                  // Tentukan widget berdasarkan 'type'
                  switch (definition['type']) {
                    case 'gender':
                      questionWidget = SimpleGenderSelection(
                        onChanged: (val) => _updateAnswer(index, val),
                        initialValue: _answers[index], // Berikan nilai awal
                      );
                      break;
                    case 'picker':
                      questionWidget = _buildInlineCupertinoPicker(
                        index, definition['min'], definition['max'],
                      );
                      break;
                    case 'choice':
                      questionWidget = ChoiceOptionsWithDescription(
                        options: definition['options'],
                        onChanged: (val) => _updateAnswer(index, val),
                        initialValue: _answers[index], // Berikan nilai awal
                      );
                      break;
                    case 'multiselect':
                      questionWidget = MultiSelectSection(
                        description: definition['description'],
                        initialSelected: _answers[index] as List<String>, // Berikan nilai awal
                        sections: [
                          MultiSelectCheckbox(
                            title: definition['sectionTitle'],
                            options: definition['options'],
                            initialSelected: _answers[index] as List<String>, // Berikan nilai awal
                            onChanged: (selected) => _updateAnswer(index, selected),
                          ),
                          // Tambahkan MultiSelectCheckbox lain jika perlu dalam satu halaman
                        ],
                      );
                      break;
                    default:
                      questionWidget = const Text('Tipe widget tidak dikenal');
                  }

                  // Bungkus widget pertanyaan dengan QuestionPageContent
                  return QuestionPageContent(
                    title: definition['title'],
                    onContinue: _onActionPressed,
                    onBack: _previousPage, // Tombol back selalu memanggil _previousPage
                    child: questionWidget,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}