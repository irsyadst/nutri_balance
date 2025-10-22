import 'dart:ui'; // <-- PERBAIKAN: Tambahkan import ini untuk ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/auth_controller.dart';
import '../widgets/primary_button.dart';
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
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (_controller.user != null && mounted) {
      if (_controller.user!.profile == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const QuestionnaireScreen()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainAppScreen(user: _controller.user!)),
        );
      }
    }
  }

  void _handleLogin() {
    if (_controller.isLoading) return;
    _controller.login(_emailController.text, _passwordController.text).then((success) {
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login gagal. Periksa kembali email dan password.")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            _buildMainUI(),
            if (_controller.isLoading) _buildLoadingModal(),
          ],
        );
      },
    );
  }

  Widget _buildMainUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: SvgPicture.asset(
                  'assets/images/NutriBalance.png',
                  height: 60,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Let's Get You\nBalanced Again",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Track your meals, stay mindful, and find your perfect balance.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(_emailController, 'Email', false),
              const SizedBox(height: 20),
              _buildTextField(_passwordController, 'Password', true),
              const SizedBox(height: 30),
              PrimaryButton(
                text: 'Sign In',
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Expanded(child: Divider(thickness: 1, endIndent: 10, color: Colors.grey)),
                  Text('OR', style: TextStyle(color: Colors.grey)),
                  Expanded(child: Divider(thickness: 1, indent: 10, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 30),
              _buildGoogleSignInButton(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Sign Up',
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Implementasi Google Sign In
      },
      icon: Image.asset(
        'assets/images/Google.png',
        height: 22,
      ),
      label: const Text(
        'Google',
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLoadingModal() {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/NutriBalance.svg',
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sign In...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
