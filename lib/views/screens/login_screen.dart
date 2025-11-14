import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/shared/primary_button.dart';
import '../widgets/shared/auth_text_field.dart';
import '../widgets/shared/social_sign_in_button.dart';
import '../widgets/shared/loading_modal.dart';
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
    _controller.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (_controller.user != null && mounted) {
      if (_controller.user!.profile == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainAppScreen(user: _controller.user!)),
        );
      }
    }
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_controller.isLoading) return;
      _controller.login(_emailController.text, _passwordController.text).then((success) {
        if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login gagal. Periksa kembali email dan password.")),
          );
        }
      });
    }
  }

  void _handleGoogleSignIn() {
    print("Google Sign In button pressed");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign In belum diimplementasi.')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            _buildMainUI(),
            if (_controller.isLoading)
              const LoadingModal(
                message: 'Signing In...',
                logoAssetPath: 'assets/images/NutriBalance.png',
              ),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/NutriBalance.png',
                    height: 60,
                    placeholderBuilder: (context) => Image.asset(
                        'assets/images/NutriBalance.png', height: 60),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Hey there,\nWelcome Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                AuthTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
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

                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.grey[600], decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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

                SocialSignInButton(
                  label: 'Google',
                  iconAssetPath: 'assets/images/Google.svg',
                  onPressed: _handleGoogleSignIn,
                ),

                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account yet? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        'Register',
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
}