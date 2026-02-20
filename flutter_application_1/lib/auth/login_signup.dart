import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/providers/authProvider.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Login" : "Signup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                  if (isLogin) {
                    await authProvider.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  } else {
                    await authProvider.signup(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Text(isLogin ? "Login" : "Signup"),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin
                    ? "Don't have account? Signup"
                    : "Already have account? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}