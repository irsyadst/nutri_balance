import 'dart:ui';
import 'package:flutter/material.dart';
// Import shared widgets
import '../../controllers/auth_controller.dart';
import '../widgets/shared/primary_button.dart';
import '../widgets/shared/auth_text_field.dart';
import '../widgets/shared/social_sign_in_button.dart';
import '../widgets/shared/loading_modal.dart';
import '../widgets/shared/auth_header.dart';
import '../widgets/shared/or_divider.dart';
import '../widgets/shared/auth_navigation_link.dart';
// Import screen tujuan
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _controller = AuthController();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose(); // Dispose controller
    super.dispose();
  }

  void _handleSignUp() {
    if (_controller.isLoading) return; // Prevent multiple taps

    // Validate form first
    if (_formKey.currentState?.validate() ?? false) {
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password dan konfirmasi password tidak cocok!")));
        return;
      }

      // Call controller to request registration
      _controller.requestRegistration(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      ).then((result) {
        if (!mounted) return; // Check if widget is still mounted

        if (result['success'] == true) {
          // Navigate to OTP screen on success
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(email: _emailController.text),
            ),
          );
        } else {
          // Show error message on failure
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'Pendaftaran gagal.')));
        }
      }).catchError((error) {
        // Handle potential errors during the API call
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi kesalahan: ${error.toString()}')));
      });
    }
  }

  // --- Fungsi untuk Google Sign In ---
  void _handleGoogleSignUp() {
    // TODO: Implementasi Google Sign Up
    print("Google Sign Up button pressed");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign Up belum diimplementasi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            _buildMainUI(), // Build the main UI
            // Show loading modal if controller is loading
            if (_controller.isLoading)
              const LoadingModal(
                message: 'Signing Up...',
                logoAssetPath: 'assets/images/NutriBalance.png',
              ),
          ],
        );
      },
    );
  }

  // Widget builder for the main UI structure
  Widget _buildMainUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      // Simple AppBar for back navigation
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54, size: 20), // Smaller back icon
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Form( // Wrap content in a Form
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Use AuthHeader widget
                const AuthHeader(
                  logoAssetPath: 'assets/images/NutriBalance.svg', // Use SVG logo if available
                  title: "Buat Akun Baru", // Updated title
                  subtitle: "Isi detail Anda untuk memulai perjalanan kesehatan.", // Updated subtitle
                ),

                // Use AuthTextField for Name
                AuthTextField(
                  controller: _nameController,
                  hintText: 'Nama Lengkap',
                  prefixIcon: Icons.person_outline,
                  validator: (value) => (value?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 20),

                // Use AuthTextField for Email
                AuthTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Email tidak boleh kosong';
                    if (!value!.contains('@') || !value.contains('.')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Use AuthTextField for Password
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) => (value?.length ?? 0) < 6 ? 'Password minimal 6 karakter' : null,
                ),
                const SizedBox(height: 20),

                // Use AuthTextField for Confirm Password
                AuthTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Konfirmasi Password',
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Konfirmasi password tidak boleh kosong';
                      if (value != _passwordController.text) return 'Password tidak cocok';
                      return null;
                    }
                ),
                const SizedBox(height: 40),

                // Use PrimaryButton for Sign Up action
                PrimaryButton(
                  text: 'Sign Up',
                  onPressed: _handleSignUp,
                ),
                const SizedBox(height: 30),

                // Use OrDivider widget
                const OrDivider(),
                const SizedBox(height: 30),

                // Use SocialSignInButton for Google
                SocialSignInButton(
                  label: 'Sign Up with Google', // Updated label
                  iconAssetPath: 'assets/images/Google.svg',
                  onPressed: _handleGoogleSignUp,
                ),
                const SizedBox(height: 40),

                // Use AuthNavigationLink widget
                AuthNavigationLink(
                  leadingText: "Sudah punya akun? ", // Updated text
                  linkText: 'Sign In',
                  onTap: () => Navigator.pop(context), // Go back to login screen
                ),
                const SizedBox(height: 20), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}