import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/auth_controller.dart';
// Import widget baru
import '../widgets/shared/primary_button.dart';
import '../widgets/shared/auth_text_field.dart';
import '../widgets/shared/social_sign_in_button.dart';
import '../widgets/shared/loading_modal.dart';
// Import screen lain
import 'main_app_screen.dart';
import 'questionnaire_screen.dart';
import 'signup_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _controller = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Tambahkan GlobalKey untuk Form
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _controller.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onAuthStateChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose(); // Dispose controller juga
    super.dispose();
  }

  void _onAuthStateChanged() {
    // Cek apakah widget masih terpasang (mounted) sebelum navigasi
    if (_controller.user != null && mounted) {
      // Cek apakah profil user null atau tidak
      if (_controller.user!.profile == null) {
        // Navigasi ke Questionnaire jika profil null
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
        );
      } else {
        // Navigasi ke MainAppScreen jika profil ada
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainAppScreen(user: _controller.user!)),
        );
      }
    }
  }

  void _handleLogin() {
    // Validasi form sebelum mencoba login
    if (_formKey.currentState?.validate() ?? false) {
      if (_controller.isLoading) return; // Hindari multiple calls
      _controller.login(_emailController.text, _passwordController.text).then((success) {
        if (!success && mounted) {
          // Tampilkan pesan error jika login gagal dan widget masih ada
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login gagal. Periksa kembali email dan password.")),
          );
        }
      });
    }
  }

  // --- Fungsi untuk Google Sign In ---
  void _handleGoogleSignIn() {
    // TODO: Implementasi Google Sign In
    print("Google Sign In button pressed");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign In belum diimplementasi.')),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Gunakan AnimatedBuilder untuk merebuild UI saat state controller berubah (isLoading)
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            _buildMainUI(), // Bangun UI utama
            // Tampilkan LoadingModal jika isLoading true
            if (_controller.isLoading)
              const LoadingModal(
                message: 'Signing In...',
                logoAssetPath: 'assets/images/NutriBalance.png', // Sesuaikan path logo
              ),
          ],
        );
      },
    );
  }

  // Widget untuk membangun UI utama (tetap di dalam screen)
  Widget _buildMainUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form( // Bungkus Column dengan Form
            key: _formKey, // Assign GlobalKey ke Form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: SvgPicture.asset( // Pastikan logo SVG ada
                    'assets/images/NutriBalance.svg', // Ganti ke SVG jika ada
                    height: 60,
                    // Placeholder jika SVG tidak ada
                    placeholderBuilder: (context) => Image.asset(
                        'assets/images/NutriBalance.png', height: 60),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Hey there,\nWelcome Back", // Ubah teks sesuai desain login
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22, // Sesuaikan ukuran font
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // Hapus deskripsi jika tidak ada di desain login
                // const SizedBox(height: 15),
                // const Text( ... ),
                const SizedBox(height: 40),

                // Gunakan AuthTextField untuk Email
                AuthTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined, // Contoh ikon
                  validator: (value) { // Tambahkan validasi email
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Gunakan AuthTextField untuk Password
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline, // Contoh ikon
                  validator: (value) { // Tambahkan validasi password
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) { // Contoh: minimal 6 karakter
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                // Tambahkan "Forgot Password?" jika ada di desain
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implementasi forgot password
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.grey[600], decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Kurangi jarak sebelum tombol login

                // Gunakan PrimaryButton
                PrimaryButton(
                  text: 'Sign In',
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, endIndent: 10, color: Color(0xFFDDDDDD))),
                    Text('OR', style: TextStyle(color: Colors.grey)),
                    Expanded(child: Divider(thickness: 1, indent: 10, color: Color(0xFFDDDDDD))),
                  ],
                ),
                const SizedBox(height: 30),

                // Gunakan SocialSignInButton
                SocialSignInButton(
                  label: 'Google',
                  iconAssetPath: 'assets/images/Google.svg', // Pastikan path benar
                  onPressed: _handleGoogleSignIn,
                ),
                // Tambahkan tombol social media lain jika perlu
                // const SizedBox(height: 15),
                // SocialSignInButton(label: 'Facebook', ...),

                const SizedBox(height: 40),
                // Teks "Don't have an account?"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account yet? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke SignUpScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        'Register', // Ganti teks ke Register
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

// === HAPUS SEMUA WIDGET BUILDER LAMA DARI SINI ===
// Widget _buildTextField(...) { ... } // HAPUS
// Widget _buildGoogleSignInButton() { ... } // HAPUS
// Widget _buildLoadingModal() { ... } // HAPUS
}