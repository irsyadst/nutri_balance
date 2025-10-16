import 'package:flutter/material.dart';
import '../models/api_service.dart';
import '../models/user_model.dart';
import '../models/storage_service.dart'; // Impor StorageService

// Controller untuk mengelola state dan logika autentikasi
class AuthController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService(); // Tambahkan instance StorageService

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    final token = await _apiService.login(email, password);

    if (token != null) {
      await _storageService.saveToken(token); // Simpan token
      _user = await _apiService.getProfile(token);
      _setLoading(false);
      notifyListeners();
      return _user != null;
    }

    _setLoading(false);
    return false;
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    _setLoading(true);
    final result = await _apiService.register(name, email, password);
    _setLoading(false);
    return result;
  }

  // Ganti nama registerAndLogin menjadi requestRegistration
  Future<Map<String, dynamic>> requestRegistration(String name, String email, String password) async {
    _setLoading(true);
    final result = await _apiService.register(name, email, password);
    _setLoading(false);
    return result;
  }

  // Fungsi baru untuk verifikasi dan login
  Future<bool> verifyOtpAndLogin(String email, String otp) async {
    _setLoading(true);
    final result = await _apiService.verifyOtp(email, otp);

    if (result['success']) {
      final token = result['token'];
      await _storageService.saveToken(token);
      _user = await _apiService.getProfile(token);
      _setLoading(false);
      if (_user != null) {
        notifyListeners(); // Memberi tahu UI bahwa user sudah login
        return true;
      }
    }

    _setLoading(false);
    return false;
  }
}

