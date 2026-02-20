import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../functions/authFunctions.dart';

class AuthProvider extends ChangeNotifier {
  final AuthFunctions _authFunctions = AuthFunctions();

  User? user;
  bool isLoading = false;

  AuthProvider() {
    _authFunctions.authStateChanges().listen((User? u) {
      user = u;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      user = await _authFunctions.login(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      user = await _authFunctions.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authFunctions.logout();
    user = null;
    notifyListeners();
  }
}