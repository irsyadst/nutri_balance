import 'dart:async';
import 'package:flutter/material.dart';
// Jangan lupa import MainAppScreen jika belum
import 'main_app_screen.dart';
// Hapus import pinput dari sini jika tidak digunakan langsung
// import 'package:pinput/pinput.dart';
import '../../controllers/auth_controller.dart';
// Import screen tujuan
import 'questionnaire_screen.dart';
// Import widget baru
import '../widgets/otp/otp_header.dart';
import '../widgets/otp/otp_input_field.dart';
import '../widgets/otp/resend_code_button.dart';
import '../widgets/shared/primary_button.dart'; // Import PrimaryButton

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthController _controller = AuthController();
  final TextEditingController _pinController = TextEditingController();
  int _countdown = 59; // Waktu countdown awal
  Timer? _timer;
  bool _isLoading = false; // State untuk loading tombol verifikasi

  @override
  void initState() {
    super.initState();
    startTimer();
    // Listener untuk AuthController tidak diperlukan lagi jika navigasi
    // ditangani langsung setelah _verifyOtp berhasil
    // _controller.addListener(_onAuthStateChanged);
  }

  void startTimer() {
    _timer?.cancel(); // Batalkan timer sebelumnya jika ada
    setState(() => _countdown = 59); // Reset countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel(); // Hentikan timer saat mencapai 0
      }
    });
  }

  // Hapus listener jika tidak digunakan
  // void _onAuthStateChanged() { ... }

  void _verifyOtp({String? pin}) {
    // Gunakan pin dari parameter (onCompleted) atau dari controller
    final otpValue = pin ?? _pinController.text;

    if (otpValue.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Harap isi semua 6 digit OTP.")));
      return;
    }
    if (_isLoading) return; // Hindari multiple calls

    setState(() => _isLoading = true);

    _controller.verifyOtpAndLogin(widget.email, otpValue).then((success) {
      // Pastikan widget masih mounted sebelum update UI atau navigasi
      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success && _controller.user != null) {
        // Navigasi setelah verifikasi berhasil
        Navigator.pushAndRemoveUntil(
          context,
          // Cek profil user setelah login berhasil
          MaterialPageRoute(builder: (context) => _controller.user!.profile == null
              ? const QuestionnaireScreen()
              : MainAppScreen(user: _controller.user!) // Navigasi ke MainApp jika profil ada
          ),
              (route) => false, // Hapus semua route sebelumnya
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Verifikasi gagal. Kode OTP salah atau telah kedaluwarsa.")));
        _pinController.clear(); // Bersihkan field OTP jika salah
      }
    }).catchError((error) {
      // Handle error jika ada (misal masalah jaringan)
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: ${error.toString()}")));
      _pinController.clear();
    });
  }

  // Fungsi untuk mengirim ulang OTP
  void _resendOtp() {
    // TODO: Implementasi logika request kirim ulang OTP ke API
    print('Requesting OTP resend for ${widget.email}');
    // Tampilkan loading atau feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mengirim ulang kode OTP... (Logika Belum Ada)')),
    );
    // Setelah request berhasil (atau gagal), restart timer
    // Contoh: Panggil API, jika sukses:
    // startTimer();
    // Jika gagal, tampilkan pesan error

    // Untuk sekarang, kita restart timer saja
    startTimer();
  }


  @override
  void dispose() {
    _timer?.cancel(); // Pastikan timer dibatalkan
    // _controller.removeListener(_onAuthStateChanged); // Hapus jika listener dihapus
    _pinController.dispose();
    _controller.dispose(); // Dispose AuthController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tema Pinput bisa didefinisikan di sini atau langsung di widget OtpInputField
    // final defaultPinTheme = ...

    return Scaffold(
      appBar: AppBar(
        // AppBar minimalis
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton( // Tombol back eksplisit
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gunakan OtpHeader
            OtpHeader(email: widget.email),

            // Gunakan OtpInputField
            OtpInputField(
              controller: _pinController,
              onCompleted: (pin) => _verifyOtp(pin: pin), // Panggil verifikasi saat selesai
              // Anda bisa teruskan tema custom jika perlu
              // defaultPinTheme: defaultPinTheme,
              // focusedPinTheme: ...,
            ),
            const SizedBox(height: 30),

            // Gunakan ResendCodeButton
            ResendCodeButton(
              countdown: _countdown,
              onResend: _resendOtp, // Panggil fungsi resend
            ),

            const Spacer(), // Dorong tombol verifikasi ke bawah

            // Gunakan PrimaryButton
            PrimaryButton(
              text: 'Verifikasi',
              onPressed: _isLoading ? null : _verifyOtp, // Panggil _verifyOtp tanpa argumen pin
              // Tambahkan child untuk loading state di dalam PrimaryButton jika belum ada
              // Jika PrimaryButton belum support loading state, gunakan ElevatedButton biasa:
              // ElevatedButton(
              //   onPressed: _isLoading ? null : _verifyOtp,
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     backgroundColor: Theme.of(context).primaryColor,
              //     foregroundColor: Colors.white,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //   ),
              //   child: _isLoading
              //       ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
              //       : const Text('Verifikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // ),
            ),
            const SizedBox(height: 40), // Padding bawah
          ],
        ),
      ),
    );
  }
}