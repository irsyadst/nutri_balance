import 'package:flutter/material.dart';
import '../models/api_service.dart';
import '../models/user_model.dart';

// Controller untuk mengelola state dan logika terkait profil pengguna
class ProfileController with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Mengambil data dari kuesioner, memformatnya, dan mengirim ke backend.
  /// Mengembalikan `User` yang sudah diperbarui jika berhasil.
  Future<User?> saveProfileFromQuestionnaire(Map<int, dynamic> answers, String token) async {
    _setLoading(true);

    try {
      // Memetakan jawaban dari Map ke objek UserProfile yang terstruktur
      final profileData = UserProfile(
        gender: answers[0] as String,
        age: answers[1] as int,
        height: (answers[2] as int).toDouble(),
        currentWeight: (answers[3] as int).toDouble(),
        goalWeight: (answers[4] as int).toDouble(),
        wakeUpTime: answers[5] as String,
        sleepTime: answers[6] as String,
        firstMealTime: answers[7] as String,
        lastMealTime: answers[8] as String,
        dailyMealIntake: answers[9] as String,
        climate: answers[10] as String,
        waterIntake: answers[11] as String,
        activityLevel: answers[12] as String,
        goals: List<String>.from(answers[13] as List),
        fastingExperience: answers[14] as String,
        healthIssues: List<String>.from(answers[15] as List),
      );

      // Memanggil ApiService untuk memperbarui profil di backend
      final updatedUser = await _apiService.updateProfile(token, profileData);

      _setLoading(false);
      return updatedUser;
    } catch (e) {
      print("Error di saveProfileFromQuestionnaire: $e");
      _setLoading(false);
      return null;
    }
  }
}
