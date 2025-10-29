import 'package:flutter/material.dart';
import 'package:funquiz_apps/main.dart'; // Impor untuk mengakses warna

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan TextTheme dari Tema
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Elemen Desain Baru ---
                const SizedBox(height: 30),
                Center(
                  child: Icon(
                    Icons.quiz_rounded,
                    size: 80,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                // --- Judul ---
                Text(
                  'Welcome to Fun Quiz',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to Test Your Knowledge?',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 40),

                // --- Form Email ---
                Text(
                  'Email',
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // --- Form Password ---
                Text(
                  'Password',
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),

                // --- Forgot Password ---
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Tombol Log In ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text('Log In'),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Tombol Sign Up ---
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kAccentColor, // Warna aksen
                      side: BorderSide(color: kAccentColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- Social Login ---
                Center(
                  child: Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(Icons.g_mobiledata),
                    const SizedBox(width: 20),
                    _buildSocialButton(Icons.facebook),
                    const SizedBox(width: 20),
                    _buildSocialButton(Icons.apple),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk tombol sosial
  Widget _buildSocialButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Icon(icon, size: 30, color: kPrimaryColor),
    );
  }
}
