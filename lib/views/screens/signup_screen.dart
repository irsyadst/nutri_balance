import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'otp_screen.dart';

// View untuk halaman pendaftaran
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controller untuk halaman ini
  final AuthController _controller = AuthController();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tidak perlu listener di sini
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password tidak cocok!")));
        return;
      }

      // Panggil requestRegistration
      _controller.requestRegistration(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      ).then((result) {
        if (result['success']! && mounted) {
          // Navigasi ke Halaman OTP jika berhasil
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(email: _emailController.text),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']!)));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Let's Get You\nBalanced Again", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                const Text("Panduan Cerdas Kalori Harian dan Puasa Intermiten Anda.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _nameController, hint: 'Nama Lengkap', icon: Icons.person_outline,
                  validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController, hint: 'Email', icon: Icons.email_outlined,
                  validator: (value) {
                    if (value!.isEmpty) return 'Email tidak boleh kosong';
                    if (!value.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController, hint: 'Password', icon: Icons.lock_outline, isPassword: true,
                  validator: (value) => value!.length < 6 ? 'Password minimal 6 karakter' : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController, hint: 'Confirm Password', icon: Icons.lock_outline, isPassword: true,
                  validator: (value) => value!.isEmpty ? 'Konfirmasi password tidak boleh kosong' : null,
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return _controller.isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(text: 'Sign Up', onPressed: _handleSignUp);
                  },
                ),
                const SizedBox(height: 20),
                const Text('OR', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                SecondaryButton(text: 'Google', icon: Icons.g_mobiledata, onPressed: () {}),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context), // Kembali ke halaman login
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Color(0xFF82B0F2), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}