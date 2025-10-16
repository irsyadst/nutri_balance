import 'package:flutter/material.dart';
import '../models/api_service.dart';
import '../models/user_model.dart';

class ProfileController with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<User?> saveProfileFromQuestionnaire(Map<String, dynamic> answers, String token) async {
    _setLoading(true);

    try {
      final profileData = UserProfile(
        gender: answers['gender'] ?? '',
        age: answers['age'] ?? 0,
        height: (answers['height'] as int? ?? 0).toDouble(),
        currentWeight: (answers['currentWeight'] as int? ?? 0).toDouble(),
        goalWeight: (answers['goalWeight'] as int? ?? 0).toDouble(),
        activityLevel: answers['activityLevel'] ?? '',
        goals: List<String>.from(answers['goals'] ?? []),
        dietaryRestrictions: List<String>.from(answers['dietaryRestrictions'] ?? []),
        allergies: List<String>.from(answers['allergies'] ?? []),
      );

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