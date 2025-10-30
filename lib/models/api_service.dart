import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'dashboard_data.dart';
import 'meal_models.dart'; // <-- Impor MealItem atau model log jika perlu
import 'food_log_model.dart'; // <-- Tambahkan import model FoodLog

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
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {'success': true, 'token': body['token']};
      }
      return {'success': false, 'message': body['message']};
    } catch (e) {
      debugPrint('Error di verifyOtp: $e');
      return {'success': false, 'message': 'Tidak dapat terhubung ke server.'};
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
        Uri.parse('$_baseUrl/user/profile'), // Endpoint PUT profile
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        // Gunakan toJson dari UserProfile
        body: jsonEncode(profile.toJson()),
      );

      debugPrint("Update Profile Status: ${response.statusCode}");
      debugPrint("Update Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse user lengkap dari response (backend mengirim user utuh)
        return _parseUserFromJson(jsonDecode(response.body)['user']);
      }
      // Handle error jika status code bukan 200
      print('Update profile failed: ${response.body}');
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

  Future<List<FoodLogEntry>> getFoodLogHistory(String token) async {
    if (token.isEmpty) {
      debugPrint('Error di getFoodLogHistory: Token kosong.');
      return []; // Kembalikan list kosong jika token tidak ada
    }
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/food/log/history'), // Endpoint: /api/food/log/history
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 20)); // Timeout lebih lama mungkin diperlukan

      debugPrint('Get History Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        // Ubah list JSON menjadi list objek FoodLogEntry
        List<FoodLogEntry> logs = body.map((dynamic item) => FoodLogEntry.fromJson(item)).toList();
        return logs;
      } else {
        debugPrint('Error di getFoodLogHistory: Status code ${response.statusCode}');
        return []; // Kembalikan list kosong jika gagal
      }
    } catch (e) {
      debugPrint('Error di getFoodLogHistory (catch): $e');
      return []; // Kembalikan list kosong jika terjadi exception
    }
  }

  Future<bool> generateMealPlan(String token, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/food/generate-meal-plan'), // Endpoint: /api/food/generate-meal-plan
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data),
      );

      debugPrint("Generate Meal Plan Status: ${response.statusCode}");
      debugPrint("Generate Meal Plan Body: ${response.body}");

      // Backend (foodController.js) mengembalikan status 201 (Created)
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error di generateMealPlan: $e');
      return false; // Gagal jika terjadi exception
    }
  }

  // Fungsi helper internal untuk mem-parsing data User dari JSON secara aman
  User _parseUserFromJson(Map<String, dynamic> data) {
    var profileData = data['profile'];
    return User(
      id: data['_id'],
      name: data['name'], // Ambil nama dari data user utama
      email: data['email'],
      profile: profileData != null ? UserProfile.fromJson(profileData) : null,
      // UserProfile.fromJson akan memparsing semua field profile
    );
  }
}