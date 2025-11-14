import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

enum OtpStatus { initial, loading, success, failure }

class OtpController with ChangeNotifier {
  final AuthController _authController;
  final String email;

  OtpController({required AuthController authController, required this.email})
      : _authController = authController {
    startTimer();
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
  }

  void startTimer() {
    _timer?.cancel();
    _countdown = 59;
    _status = OtpStatus.initial;
    _errorMessage = null;
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
      } else {
        timer.cancel();
      }
      notifyListeners();
    });
  }

  Future<bool> verifyOtp({String? pin}) async {
    final otpToVerify = pin ?? _otpValue;

    if (otpToVerify.length != 6) {
      _status = OtpStatus.failure;
      _errorMessage = "Harap isi semua 6 digit OTP.";
      notifyListeners();
      return false;
    }

    if (_status == OtpStatus.loading) return false;

    _status = OtpStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
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
    print('Requesting OTP resend for $email');

    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();

  }
}