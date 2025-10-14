import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'questionnaire_screen.dart'; // Impor halaman tujuan

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
    // View "mendengarkan" setiap perubahan state dari Controller
    _controller.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onAuthStateChanged);
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi ini akan dipanggil setiap kali ada perubahan di Controller
  void _onAuthStateChanged() {
    // Jika Controller memiliki data user (artinya login berhasil)
    if (_controller.user != null && mounted) {
      // Langsung navigasi ke halaman kuesioner
      // `pushAndRemoveUntil` akan menghapus semua halaman sebelumnya (login, signup)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
            (Route<dynamic> route) => false, // Predikat ini menghapus semua rute
      );
    }
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password tidak cocok!"),
          backgroundColor: Colors.red,
        ));
        return;
      }

      // View meneruskan aksi pendaftaran dan login ke Controller
      _controller.registerAndLogin(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      ).then((result) {
        // Hanya tampilkan snackbar jika proses gagal
        if (!result['success']! && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result['message']!),
            backgroundColor: Colors.red,
          ));
        }
        // Navigasi tidak lagi dilakukan di sini, melainkan ditangani oleh listener `_onAuthStateChanged`
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

