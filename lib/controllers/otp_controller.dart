import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart'; // Import User model
import 'auth_controller.dart'; // Import AuthController untuk logic verifikasi

// Enum untuk status verifikasi OTP
enum OtpStatus { initial, loading, success, failure }

class OtpController with ChangeNotifier {
  // Deklarasikan field _authController
  final AuthController _authController;
  final String email;

  // Perbaiki constructor untuk menginisialisasi field _authController
  OtpController({required AuthController authController, required this.email})
      : _authController = authController { // Inisialisasi field di sini
    startTimer(); // Mulai timer saat controller dibuat
  }

  // --- State ---
  String _otpValue = '';
  String get otpValue => _otpValue;

  int _countdown = 59;
  int get countdown => _countdown;

  OtpStatus _status = OtpStatus.initial;
  OtpStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? get verifiedUser => _authController.user; // Ambil user dari AuthController

  Timer? _timer;
  bool get canResend => _countdown == 0;

  // --- Logic ---
  void setOtpValue(String value) {
    _otpValue = value;
    // Tidak perlu notifyListeners() di sini jika input field dikelola di UI
  }

  void startTimer() {
    _timer?.cancel();
    _countdown = 59;
    _status = OtpStatus.initial; // Reset status
    _errorMessage = null;
    notifyListeners(); // Update UI untuk countdown awal
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
      } else {
        timer.cancel();
      }
      notifyListeners(); // Update UI setiap detik
    });
  }

  Future<bool> verifyOtp({String? pin}) async {
    final otpToVerify = pin ?? _otpValue; // Gunakan pin dari parameter atau state

    if (otpToVerify.length != 6) {
      _status = OtpStatus.failure;
      _errorMessage = "Harap isi semua 6 digit OTP.";
      notifyListeners();
      return false;
    }

    if (_status == OtpStatus.loading) return false; // Hindari multiple calls

    _status = OtpStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Panggil verifyOtpAndLogin dari instance _authController
      final success = await _authController.verifyOtpAndLogin(email, otpToVerify);
      if (success) {
        _status = OtpStatus.success;
        notifyListeners();
        return true;
      } else {
        _status = OtpStatus.failure;
        _errorMessage = "Verifikasi gagal. Kode OTP salah atau telah kedaluwarsa.";
        notifyListeners();
        return false;
      }
    } catch (error) {
      _status = OtpStatus.failure;
      _errorMessage = "Terjadi kesalahan: ${error.toString()}";
      notifyListeners();
      return false;
    }
  }

  // Fungsi untuk mengirim ulang OTP
  void resendOtp() {
    if (!canResend || _status == OtpStatus.loading) return;

    // TODO: Implementasi logika request kirim ulang OTP ke API
    print('Requesting OTP resend for $email');
    // Tampilkan loading atau feedback sementara (opsional)
    // _status = OtpStatus.loading; notifyListeners();

    // Setelah request berhasil (atau gagal), restart timer
    // Contoh: Panggil API, jika sukses:
    // startTimer();
    // Jika gagal, tampilkan pesan error
    // _status = OtpStatus.failure; _errorMessage = "Gagal mengirim ulang"; notifyListeners();

    // Untuk sekarang, kita restart timer saja
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    // Jangan dispose _authController di sini jika itu shared
  }
}