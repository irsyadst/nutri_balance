// lib/controllers/splash_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/storage_service.dart';
import '../models/api_service.dart';
import '../models/user_model.dart';

// Enum untuk status navigasi
enum SplashStatus {
  loading,
  unauthenticated, // Arahkan ke Onboarding
  needsProfile,    // Arahkan ke Questionnaire
  authenticated,     // Arahkan ke MainApp
  failure          // Menampilkan error (opsional)
}

class SplashController with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();

  SplashStatus _status = SplashStatus.loading;
  SplashStatus get status => _status;

  User? _user;
  User? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SplashController() {
    _checkSession(); // Langsung panggil pengecekan sesi
  }

  Future<void> _checkSession() async {
    // Beri sedikit delay agar splash screen terlihat
    await Future.delayed(const Duration(seconds: 2));

    try {
      final token = await _storageService.getToken();

      if (token != null) {
        print("Token found, trying to get profile...");
        _user = await _apiService.getProfile(token); // Coba fetch profil

        if (_user != null) {
          // Jika user berhasil didapatkan (token valid & profil ada)
          print("Profile fetched successfully for ${_user!.name}");
          if (_user!.profile != null) {
            // Jika profil lengkap -> MainAppScreen
            print("Profile complete, navigating to MainAppScreen");
            _status = SplashStatus.authenticated;
          } else {
            // Jika profil belum lengkap -> QuestionnaireScreen
            print("Profile incomplete, navigating to QuestionnaireScreen");
            _status = SplashStatus.needsProfile;
          }
        } else {
          // Jika token ada tapi fetch profile gagal (token invalid)
          print("Failed to fetch profile with token, deleting invalid token.");
          await _storageService.deleteToken(); // Hapus token invalid
          _status = SplashStatus.unauthenticated;
        }
      } else {
        // Jika token tidak ada
        print("No token found, navigating to OnboardingScreen");
        _status = SplashStatus.unauthenticated;
      }
    } catch (e) {
      print("Error in _checkSession: $e");
      _errorMessage = "Gagal terhubung ke server.";
      _status = SplashStatus.failure; // Status failure opsional
    }

    // Beri tahu semua listener (yaitu Splash Screen) bahwa status telah berubah
    notifyListeners();
  }
}