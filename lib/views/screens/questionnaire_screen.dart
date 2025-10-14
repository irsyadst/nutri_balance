import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';
import '../widgets/question_widgets.dart';
import 'main_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk mengambil token

// Halaman utama untuk alur kuesioner
class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});
  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  final ProfileController _profileController = ProfileController();
  int _currentStep = 0;
  final int _totalSteps = 16;
  final Map<int, dynamic> _answers = {};

  void _nextPage() async {
    // Validasi sederhana sebelum lanjut
    if (_answers[_currentStep] == null ||
        (_answers[_currentStep] is String && (_answers[_currentStep] as String).isEmpty) ||
        (_answers[_currentStep] is List && (_answers[_currentStep] as List).isEmpty) ) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Harap pilih jawaban sebelum melanjutkan.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      // Langkah terakhir: Simpan profil
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sesi tidak valid. Silakan login kembali.'),
            backgroundColor: Colors.red,
          ));
        }
        return;
      }

      final updatedUser = await _profileController.saveProfileFromQuestionnaire(_answers, token);

      if (updatedUser != null && mounted) {
        // Jika berhasil, navigasi ke halaman utama
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainAppScreen(user: updatedUser)),
              (Route<dynamic> route) => false,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Gagal menyimpan profil. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      Navigator.pop(context); // Kembali ke halaman login/signup
    }
  }

  void _updateAnswer(int step, dynamic answer) {
    // Tidak perlu setState di sini karena tidak ada UI yang bergantung pada _answers secara langsung
    _answers[step] = answer;
    debugPrint("Step $step answered: $answer");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: _previousPage,
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF82B0F2)),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                '${_currentStep + 1}/$_totalSteps',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _profileController,
        builder: (context, child) {
          return _profileController.isLoading
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Menyimpan profil Anda...", style: TextStyle(fontSize: 16)),
              ],
            ),
          )
              : child!;
        },
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) => setState(() => _currentStep = page),
          children: [
            // Step 1: Jenis Kelamin
            QuestionPageContent(title: 'Apa jenis kelaminmu??', description: 'Untuk mempersonalisasi pengalaman puasa Anda...', onContinue: _nextPage,
              child: GenderSelection(onChanged: (value) => _updateAnswer(0, value)),
            ),
            // Step 2: Usia
            QuestionPageContent(title: 'Berapa usiamu?', description: 'Usia Anda membantu kami menyesuaikan rekomendasi...', onContinue: _nextPage,
              child: WheelNumberPicker(minValue: 15, maxValue: 80, initialValue: 25, unit: 'tahun', onChanged: (value) => _updateAnswer(1, value)),
            ),
            // Step 3: Tinggi Badan
            QuestionPageContent(title: 'Berapa tinggi kamu?', description: 'Tinggi badan Anda membantu kami menghitung BMI Anda.', onContinue: _nextPage,
              child: WheelNumberPicker(minValue: 140, maxValue: 220, initialValue: 170, unit: 'cm', onChanged: (value) => _updateAnswer(2, value)),
            ),
            // Step 4: Berat Badan Saat Ini
            QuestionPageContent(title: 'Berapa berat badanmu sekarang?', description: 'Ini memungkinkan kami menetapkan tujuan yang realistis.', onContinue: _nextPage,
              child: WheelNumberPicker(minValue: 40, maxValue: 150, initialValue: 65, unit: 'kg', onChanged: (value) => _updateAnswer(3, value)),
            ),
            // Step 5: Berat Badan Ideal
            QuestionPageContent(title: 'Menetapkan berat ideal Anda?', description: 'Berapa berat badan yang ingin Anda capai?', onContinue: _nextPage,
              child: WheelNumberPicker(minValue: 40, maxValue: 150, initialValue: 60, unit: 'kg', onChanged: (value) => _updateAnswer(4, value)),
            ),
            // Step 6: Waktu Bangun
            QuestionPageContent(title: 'Jam berapa kamu biasanya memulai harimu?', description: 'Ini membantu kami menjadwalkan waktu puasa Anda.', onContinue: _nextPage,
              child: WheelTimePicker(onChanged: (value) => _updateAnswer(5, value)),
            ),
            // Step 7: Waktu Tidur
            QuestionPageContent(title: 'Jam berapa kamu biasanya tidur?', description: 'Ini membantu merencanakan jadwal puasa Anda.', onContinue: _nextPage,
              child: WheelTimePicker(onChanged: (value) => _updateAnswer(6, value)),
            ),
            // Step 8: Waktu Makan Pertama
            QuestionPageContent(title: 'Kapan Anda biasanya makan pertama kali?', description: 'Informasi ini penting untuk merancang jendela makan.', onContinue: _nextPage,
              child: WheelTimePicker(onChanged: (value) => _updateAnswer(7, value)),
            ),
            // Step 9: Waktu Makan Terakhir
            QuestionPageContent(title: 'Kapan Anda biasanya makan terakhir kali?', description: 'Ini membantu kami menentukan durasi puasa Anda.', onContinue: _nextPage,
              child: WheelTimePicker(onChanged: (value) => _updateAnswer(8, value)),
            ),
            // Step 10: Asupan Makanan Harian
            QuestionPageContent(title: 'Bagaimana asupan makanan harian Anda?', description: 'Memahami kebiasaan makan Anda membantu kami.', onContinue: _nextPage,
              child: ChoiceOptions(options: const ['1', '2', '3', '4', '5+'], onChanged: (value) => _updateAnswer(9, value.isNotEmpty ? value.first : '')),
            ),
            // Step 11: Iklim
            QuestionPageContent(title: 'Bagaimana iklim di daerah Anda?', description: 'Ini dapat mempengaruhi hidrasi Anda.', onContinue: _nextPage,
              child: ChoiceOptions(options: const ['Panas', 'Berawan', 'Dingin'], onChanged: (value) => _updateAnswer(10, value.isNotEmpty ? value.first : '')),
            ),
            // Step 12: Asupan Air Mineral
            QuestionPageContent(title: 'Berapa banyak air mineral yang Anda minum?', description: 'Tetap terhidrasi penting untuk puasa yang sukses.', onContinue: _nextPage,
              child: ChoiceOptions(options: const ['Aku kebanyakan minum minuman lain', 'Sekitar 2 gelas', '2 sampai 6 gelas', 'Lebih dari 6 gelas'], onChanged: (value) => _updateAnswer(11, value.isNotEmpty ? value.first : '')),
            ),
            // Step 13: Tingkat Aktivitas
            QuestionPageContent(title: 'Bagaimana tingkat aktivitas Anda?', description: 'Ini memengaruhi kebutuhan kalori Anda.', onContinue: _nextPage,
              child: ChoiceOptionsWithDescription(options: const [
                {'title': 'Menetap', 'description': 'Aktivitas fisik terbatas, kebanyakan duduk.'},
                {'title': 'Aktivitas Ringan', 'description': 'Beberapa gerakan sepanjang hari, seperti berjalan ringan.'},
                {'title': 'Aktivitas Sedang', 'description': 'Olahraga teratur atau aktivitas fisik, seperti jogging.'},
                {'title': 'Sangat Aktif', 'description': 'Aktivitas fisik atau latihan yang intens setiap hari.'},
              ], onChanged: (value) => _updateAnswer(12, value)),
            ),
            // Step 14: Tujuan
            QuestionPageContent(title: 'Apa yang ingin Anda capai?', description: 'Pilih semua yang berlaku.', onContinue: _nextPage,
              child: ChoiceOptions(options: const ['Penurunan berat badan', 'Meningkatkan kesehatan', 'Peningkatan tingkat energi', 'Kesehatan metabolisme', 'Meningkatkan fokus mental'], allowMultiple: true, onChanged: (value) => _updateAnswer(13, value)),
            ),
            // Step 15: Pengalaman Puasa
            QuestionPageContent(title: 'Apakah Anda pernah berpuasa?', description: 'Ini membantu kami menyesuaikan rencana Anda.', onContinue: _nextPage,
              child: ChoiceOptions(options: const ['Tidak, ini pertama saya', 'Ya, Kadang-Kadang', 'Ya, Secara Teratur'], onChanged: (value) => _updateAnswer(14, value.isNotEmpty ? value.first : '')),
            ),
            // Step 16: Masalah Kesehatan
            QuestionPageContent(title: 'Masalah kesehatan apa yang perlu kami ketahui?', description: 'Ini penting untuk keselamatan Anda.', onContinue: _nextPage,
              child: ChoiceOptions(options: const ['Aku tidak punya masalah sehat', 'Diabetes', 'Tekanan darah tinggi', 'Kolesterol tinggi', 'Gangguan tiroid'], allowMultiple: true, onChanged: (value) => _updateAnswer(15, value)),
            ),
          ],
        ),
      ),
    );
  }
}

