import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'dashboard_data.dart';
import 'meal_models.dart'; // <-- Impor MealPlan dan Food
import 'food_log_model.dart'; // <-- Impor model FoodLog

// Service untuk Komunikasi dengan Backend
class ApiService {
  final String _baseUrl = 'https://nutri-balance-backend.onrender.com/api';

  // --- FUNGSI AUTH & USER (Tetap sama) ---
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

  Future<User?> updateProfile(String token, UserProfile profile) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/user/profile'), // Endpoint PUT profile
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(profile.toJson()),
      );

      debugPrint("Update Profile Status: ${response.statusCode}");
      debugPrint("Update Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        return _parseUserFromJson(jsonDecode(response.body)['user']);
      }
      print('Update profile failed: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('Error di updateProfile: $e');
      return null;
    }
  }

  Future<DashboardData?> getDashboardData(String token) async {
    // CATATAN: Endpoint '/dashboard' tidak ada di routes Anda.
    // Ini mungkin akan error nanti, tapi kita biarkan dulu.
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

  // --- FUNGSI FOOD & MEAL PLAN (DIPERBAIKI) ---

  Future<List<FoodLogEntry>> getFoodLogHistory(String token) async {
    if (token.isEmpty) {
      debugPrint('Error di getFoodLogHistory: Token kosong.');
      return [];
    }
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/log/history'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 20));

      debugPrint('Get History Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<FoodLogEntry> logs = body.map((dynamic item) => FoodLogEntry.fromJson(item)).toList();
        return logs;
      } else {
        debugPrint('Error di getFoodLogHistory: Status code ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error di getFoodLogHistory (catch): $e');
      return [];
    }
  }

  Future<bool> generateMealPlan(String token, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/food/generate-meal-plan'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data),
      );

      debugPrint("Generate Meal Plan Status: ${response.statusCode}");
      debugPrint("Generate Meal Plan Body: ${response.body}");

      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error di generateMealPlan: $e');
      return false;
    }
  }

  Future<List<MealPlan>> getMealPlan(String token, String date) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/meal-planner?date=$date'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return mealPlanFromJson(response.body);
    } else {
      print('Gagal mengambil meal plan: ${response.body}');
      throw Exception('Gagal mengambil meal plan');
    }
  }

  // --- FUNGSI BARU (FIX) ---

  Future<List<String>> getFoodCategories() async { // Token tidak perlu
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/foods/categories'),
      );
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.cast<String>();
      } else {
        throw Exception('Gagal mengambil kategori: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error di getFoodCategories: $e');
      throw Exception('Gagal mengambil kategori');
    }
  }

  // --- [PERBAIKAN DI SINI] ---
  /// Mencari makanan di database berdasarkan nama ATAU kategori
  Future<List<Food>> searchFoods({String? searchQuery, String? category}) async {
    try {
      // Buat map untuk query parameters
      final Map<String, String> queryParameters = {};

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParameters['search'] = searchQuery;
      }
      if (category != null && category.isNotEmpty) {
        queryParameters['category'] = category;
      }

      // Buat URL dengan query parameters
      final uri = Uri.parse('$_baseUrl/foods').replace(
        queryParameters: queryParameters, // Endpoint: /api/foods?search=...&category=...
      );

      final response = await http.get(uri); // Tidak perlu token

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        // Map hasil JSON ke List<Food>
        return body.map((dynamic item) => Food.fromJson(item)).toList();
      } else {
        throw Exception('Gagal mencari makanan: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error di searchFoods: $e');
      throw Exception('Gagal mencari makanan');
    }
  }
  // --- [AKHIR PERBAIKAN] ---

  Future<void> logFood({
    required String token,
    required String foodId,
    required double quantity,
    required String mealType,
    required String date,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/log/food'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'foodId': foodId,
          'quantity': quantity,
          'mealType': mealType,
          'date': date,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Gagal mencatat makanan: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error di logFood: $e');
      throw Exception('Gagal mencatat makanan');
    }
  }

  // --- Helper Internal ---
  User _parseUserFromJson(Map<String, dynamic> data) {
    var profileData = data['profile'];
    return User(
      id: data['_id'],
      name: data['name'],
      email: data['email'],
      profile: profileData != null ? UserProfile.fromJson(profileData) : null,
    );
  }
}

