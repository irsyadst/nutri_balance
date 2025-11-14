import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_controller.dart';
import '../models/user_model.dart';

enum QuestionnaireStatus { initial, loading, saving, success, failure }

class QuestionnaireController with ChangeNotifier {
  final ProfileController _profileController = ProfileController();

  // --- State ---
  final PageController pageController = PageController();
  int _currentStep = 0;
  int get currentStep => _currentStep;


  final Map<int, dynamic> _answers = {
    0: 'Pria',
    1: 24,
    2: 165,
    3: 50,
    4: 65,
    5: 'Cukup Aktif',
    6: 'Penurunan Berat Badan',
    7: <String>[],
    8: <String>[],
  };
  Map<int, dynamic> get answers => Map.unmodifiable(_answers);

  QuestionnaireStatus _status = QuestionnaireStatus.initial;
  QuestionnaireStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _savedUser;
  User? get savedUser => _savedUser;

  late final List<Map<String, dynamic>> questionDefinitions;


  static const List<Map<String, String>> activityLevelOptions = [

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
  ];
  static const List<Map<String, String>> dietGoalOptions = [
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
  ];
  static const List<String> dietaryRestrictionOptions = ['Vegetarian', 'Vegan', 'Halal', 'Keto', 'Mediterania'];
  static const List<String> allergyOptions = ['Gluten', 'Susu', 'Gula', 'Kedelai', 'Kerang', 'Kacang'];


  QuestionnaireController() {
    _initializeQuestions();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureInitialAnswersValid());
  }

  void _initializeQuestions() {
    questionDefinitions = [
      {'title': 'Jenis Kelamin Anda?', 'type': 'gender'},
      {'title': 'Berapa usiamu?', 'type': 'picker', 'min': 15, 'max': 80},
      {'title': 'Berapa tinggi badanmu (cm)?', 'type': 'picker', 'min': 140, 'max': 220},
      {'title': 'Berat Badan Saat Ini (kg)?', 'type': 'picker', 'min': 40, 'max': 150},
      {'title': 'Target Berat Badan (kg)?', 'type': 'picker', 'min': 40, 'max': 150},
      {'title': 'Seberapa aktif Anda?', 'type': 'choice', 'options': activityLevelOptions},
      {'title': 'Apa tujuan diet Anda?', 'type': 'choice', 'options': dietGoalOptions},
      {'title': 'Preferensi Makanan Anda', 'type': 'multiselect', 'description': 'Beritahu kami tentang pantangan makanan Anda.', 'sectionTitle': 'Pantangan Makan', 'options': dietaryRestrictionOptions},
      {'title': 'Preferensi Makanan Anda', 'type': 'multiselect', 'description': 'Beritahu kami tentang alergi makanan Anda.', 'sectionTitle': 'Alergi', 'options': allergyOptions},
    ];
  }

  void _ensureInitialAnswersValid() {
    questionDefinitions.asMap().forEach((index, definition) {
      updateAnswer(index, _answers[index]);
    });
  }

  // --- Logic ---
  void updateAnswer(int step, dynamic answer) {
    if (_answers[step] != answer) {
      _answers[step] = answer;
      print("Controller Updated _answers[$step]: ${_answers[step]}");
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentStep < questionDefinitions.length) { // Cek jika bukan halaman summary
      pageController.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void previousPage() {
    if (_currentStep > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void jumpToSummary() {
    if (_currentStep != questionDefinitions.length) {
      pageController.jumpToPage(questionDefinitions.length);
    }
  }

  void updateCurrentStep(int step) {
    if (_currentStep != step) {
      _currentStep = step;
      notifyListeners();
    }
  }


  Future<void> saveProfile() async {
    if (_status == QuestionnaireStatus.saving) return;

    _status = QuestionnaireStatus.saving;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final goalsList = _answers[6] is String && (_answers[6] as String).isNotEmpty
          ? [_answers[6]]
          : <String>[];

      final Map<String, dynamic> profileData = {
        'gender': _answers[0], 'age': _answers[1], 'height': _answers[2],
        'currentWeight': _answers[3], 'goalWeight': _answers[4], 'activityLevel': _answers[5],
        'goals': goalsList,
        'dietaryRestrictions': _answers[7] ?? [],
        'allergies': _answers[8] ?? [],
      };

      _savedUser = await _profileController.saveProfileFromQuestionnaire(profileData, token);

      if (_savedUser != null) {
        _status = QuestionnaireStatus.success;
      } else {
        _status = QuestionnaireStatus.failure;
        _errorMessage = 'Gagal menyimpan profil.';
      }
    } catch (e) {
      _status = QuestionnaireStatus.failure;
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      print("Error di saveProfile: $e");
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}