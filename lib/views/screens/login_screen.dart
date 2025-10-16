import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'main_app_screen.dart';
import 'questionnaire_screen.dart';
import 'signup_screen.dart';

// View untuk halaman Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Menginstansiasi Controller untuk halaman ini
  final AuthController _controller = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // View "mendengarkan" setiap perubahan state dari Controller
    _controller.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onAuthStateChanged);
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi yang dijalankan saat ada perubahan di Controller
  void _onAuthStateChanged() {
    // Jika Controller memiliki data user (artinya login berhasil)
    if (_controller.user != null && mounted) {
      if (_controller.user!.profile == null) {
        // Jika profil kosong, navigasi ke kuesioner
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const QuestionnaireScreen()));
      } else {
        // Jika profil ada, navigasi ke halaman utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainAppScreen(user: _controller.user!)),
        );
      }
    }
  }

  // Fungsi yang dipanggil saat tombol "Sign In" ditekan
  void _handleLogin() {
    // View meneruskan aksi ke Controller
    _controller.login(_emailController.text, _passwordController.text).then((success) {
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login gagal. Periksa kembali email dan password.")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              const Text("Let's Get You\nBalanced Again", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const Text("Track your meals, stay mindful, and find your perfect balance.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 30),
              CustomTextField(controller: _emailController, hint: 'Email', icon: Icons.email_outlined),
              const SizedBox(height: 20),
              CustomTextField(controller: _passwordController, hint: 'Password', icon: Icons.lock_outline, isPassword: true),
              const SizedBox(height: 40),
              // Widget ini akan otomatis rebuild saat state `isLoading` di Controller berubah
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return _controller.isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(text: 'Sign In', onPressed: _handleLogin);
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
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Color(0xFF82B0F2), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}