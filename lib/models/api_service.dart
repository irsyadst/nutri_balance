import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'dashboard_data.dart';

// Service untuk Komunikasi dengan Backend
class ApiService {
  final String _baseUrl = 'https://nutri-balance-backend.onrender.com/api';

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final responseBody = jsonDecode(response.body);
      return {'success': response.statusCode == 201, 'message': responseBody['message'] ?? 'Terjadi kesalahan'};
    } catch (e) {
      debugPrint('Error di register: $e');
      return {'success': false, 'message': 'Tidak dapat terhubung ke server.'};
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return response.statusCode == 200 ? jsonDecode(response.body)['token'] : null;
    } catch (e) {
      debugPrint('Error di login: $e');
      return null;
    }
  }

  Future<User?> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return _parseUserFromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint('Error di getProfile: $e');
      return null;
    }
  }

  /// Mengirim data profil yang sudah diperbarui ke backend.
  Future<User?> updateProfile(String token, UserProfile profile) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/user/profile'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(profile.toJson()),
      );

      debugPrint("Update Profile Status: ${response.statusCode}");
      debugPrint("Update Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        return _parseUserFromJson(jsonDecode(response.body)['user']);
      }
      return null;
    } catch (e) {
      debugPrint('Error di updateProfile: $e');
      return null;
    }
  }

  Future<DashboardData?> getDashboardData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/dashboard'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DashboardData(
          consumedKcal: (data['consumed']['calories'] ?? 0).toInt(),
          targetKcal: (data['targets']['targetCalories'] ?? 0).toInt(),
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error di getDashboardData: $e');
      return null;
    }
  }

  // Fungsi helper internal untuk mem-parsing data User dari JSON secara aman
  User _parseUserFromJson(Map<String, dynamic> data) {
    return User(
      id: data['_id'],
      name: data['name'],
      email: data['email'],
      profile: data['profile'] != null ? UserProfile(
        gender: data['profile']['gender'] ?? '',
        age: data['profile']['age'] ?? 0,
        height: (data['profile']['height'] ?? 0.0).toDouble(),
        currentWeight: (data['profile']['currentWeight'] ?? 0.0).toDouble(),
        goalWeight: (data['profile']['goalWeight'] ?? 0.0).toDouble(),
        wakeUpTime: data['profile']['wakeUpTime'] ?? '',
        sleepTime: data['profile']['sleepTime'] ?? '',
        firstMealTime: data['profile']['firstMealTime'] ?? '',
        lastMealTime: data['profile']['lastMealTime'] ?? '',
        dailyMealIntake: data['profile']['dailyMealIntake'] ?? '',
        climate: data['profile']['climate'] ?? '',
        waterIntake: data['profile']['waterIntake'] ?? '',
        activityLevel: data['profile']['activityLevel'] ?? '',
        goals: List<String>.from(data['profile']['goals'] ?? []),
        fastingExperience: data['profile']['fastingExperience'] ?? '',
        healthIssues: List<String>.from(data['profile']['healthIssues'] ?? []),
        targetCalories: data['profile']['targetCalories'],
      ) : null,
    );
  }
}

