import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/otp_controller.dart';
import 'main_app_screen.dart';
import 'questionnaire_screen.dart';
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
  final AuthController _authController = AuthController();
  late OtpController _otpController;
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _otpController = OtpController(authController: _authController, email: widget.email);
    _otpController.addListener(_handleOtpStateChange);
  }

  void _handleOtpStateChange() {
    if (_otpController.status == OtpStatus.success && _otpController.verifiedUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => _otpController.verifiedUser!.profile == null
                    ? const QuestionnaireScreen()
                    : MainAppScreen(user: _otpController.verifiedUser!)),
                (route) => false,
          );
        }
      });
    } else if (_otpController.status == OtpStatus.failure && _otpController.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_otpController.errorMessage!)),
          );
          _pinController.clear();
        }
      });
    }
  }

  @override
  void dispose() {
    _otpController.removeListener(_handleOtpStateChange);
    _otpController.dispose();
    _authController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onCompleted: (pin) => _otpController.verifyOtp(pin: pin),
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
                  onPressed: isLoading ? null : () => _otpController.verifyOtp(pin: _pinController.text),
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