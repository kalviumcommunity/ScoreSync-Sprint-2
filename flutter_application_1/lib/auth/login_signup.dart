// login_signup.dart
// Simple Login and Sign Up screen using Firebase Auth

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Hardcoded test account for demo/learning purposes
const String kTestEmail = 'test@scoresync.com';
const String kTestPassword = 'Test@1234';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final AuthService _authService = AuthService();

  // Pre-filled with test credentials
  final TextEditingController _emailController =
      TextEditingController(text: kTestEmail);
  final TextEditingController _passwordController =
      TextEditingController(text: kTestPassword);

  bool _isLogin = true;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    String? error;
    if (_isLogin) {
      error = await _authService.signIn(email, password);
    } else {
      error = await _authService.signUp(email, password);
    }

    setState(() {
      _isLoading = false;
      _errorMessage = error ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 60, color: Colors.deepPurple),
            const SizedBox(height: 16),

            Text(
              _isLogin ? 'Welcome Back!' : 'Create Account',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ── Test credentials info box ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                border: Border.all(color: Colors.deepPurple.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔑  Test Account',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 4),
                  Text('Email    : test@scoresync.com'),
                  Text('Password : Test@1234'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Email field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 10),

            // Error message
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_isLogin ? 'Login' : 'Sign Up'),
              ),
            ),
            const SizedBox(height: 12),

            // Toggle between Login / Sign Up
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                  _errorMessage = '';
                });
              },
              child: Text(
                _isLogin
                    ? "Don't have an account? Sign Up"
                    : 'Already have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
