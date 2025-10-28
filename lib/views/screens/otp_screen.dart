import 'dart:async';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart'; // Tetap perlu untuk dependency
import '../../controllers/otp_controller.dart'; // Import controller baru
// Import screen tujuan
import 'main_app_screen.dart';
import 'questionnaire_screen.dart';
// Import widget
import '../widgets/otp/otp_header.dart';
import '../widgets/otp/otp_input_field.dart';
import '../widgets/otp/resend_code_button.dart';
import '../widgets/shared/primary_button.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Hanya AuthController yang di-instantiate di sini (atau didapat dari Provider)
  final AuthController _authController = AuthController();
  // OtpController akan dibuat di initState
  late OtpController _otpController;
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Buat OtpController, berikan AuthController sebagai dependency
    _otpController = OtpController(authController: _authController, email: widget.email);
    // Tambahkan listener untuk navigasi saat status success
    _otpController.addListener(_handleOtpStateChange);
  }

  void _handleOtpStateChange() {
    if (_otpController.status == OtpStatus.success && _otpController.verifiedUser != null) {
      // Navigasi setelah verifikasi berhasil
      WidgetsBinding.instance.addPostFrameCallback((_) { // Pastikan navigasi setelah build
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => _otpController.verifiedUser!.profile == null
                    ? const QuestionnaireScreen()
                    : MainAppScreen(user: _otpController.verifiedUser!)),
                (route) => false, // Hapus semua route sebelumnya
          );
        }
      });
    } else if (_otpController.status == OtpStatus.failure && _otpController.errorMessage != null) {
      // Tampilkan SnackBar jika gagal
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_otpController.errorMessage!)),
          );
          _pinController.clear(); // Bersihkan field OTP jika salah
        }
      });
    }
  }

  @override
  void dispose() {
    _otpController.removeListener(_handleOtpStateChange);
    _otpController.dispose();
    _authController.dispose(); // Dispose AuthController jika tidak shared
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan ListenableBuilder untuk mendengarkan perubahan pada OtpController
    return ListenableBuilder(
      listenable: _otpController,
      builder: (context, child) {
        bool isLoading = _otpController.status == OtpStatus.loading;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
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
                OtpHeader(email: widget.email),
                OtpInputField(
                  controller: _pinController,
                  // Panggil verifyOtp di controller
                  onCompleted: (pin) => _otpController.verifyOtp(pin: pin),
                  // Set nilai OTP di controller saat berubah (opsional, tergantung kebutuhan)
                  // onChanged: (value) => _otpController.setOtpValue(value),
                ),
                const SizedBox(height: 30),
                ResendCodeButton(
                  countdown: _otpController.countdown,
                  // Panggil resendOtp di controller
                  onResend: _otpController.resendOtp,
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'Verifikasi',
                  // Nonaktifkan tombol saat loading
                  onPressed: isLoading ? null : () => _otpController.verifyOtp(pin: _pinController.text),
                  // TODO: Tambahkan state loading di dalam PrimaryButton jika perlu
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}