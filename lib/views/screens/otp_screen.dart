import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/auth_controller.dart';
import 'questionnaire_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthController _controller = AuthController();
  final TextEditingController _pinController = TextEditingController();
  int _countdown = 59;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    _controller.addListener(_onAuthStateChanged);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _onAuthStateChanged() {
    if (_controller.user != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
            (route) => false,
      );
    }
  }

  void _verifyOtp() {
    if (_pinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Harap isi semua 6 digit OTP.")));
      return;
    }
    setState(() => _isLoading = true);
    _controller.verifyOtpAndLogin(widget.email, _pinController.text).then((success) {
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verifikasi gagal. Kode OTP salah atau telah kedaluwarsa.")));
      }
      setState(() => _isLoading = false);
    });
  }


  @override
  void dispose() {
    _timer?.cancel();
    _controller.removeListener(_onAuthStateChanged);
    _controller.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Verifikasi Kode OTP",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              "Masukkan kode OTP yang telah kami kirimkan ke email Anda ${widget.email}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            Pinput(
              length: 6,
              controller: _pinController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: const Color(0xFF007BFF)),
                ),
              ),
              onCompleted: (pin) => _verifyOtp(),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: _countdown == 0 ? () { /* Logika Kirim Ulang */ } : null,
              child: Text(
                _countdown == 0 ? "Kirim Ulang Kode" : "Kirim Ulang Kode (00:${_countdown.toString().padLeft(2, '0')})",
                style: TextStyle(color: _countdown == 0 ? const Color(0xFF007BFF) : Colors.grey, fontSize: 16),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF007BFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text('Verifikasi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}