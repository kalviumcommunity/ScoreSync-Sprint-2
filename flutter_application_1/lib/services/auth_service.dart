// auth_service.dart
// Handles Firebase Authentication: sign up, sign in, sign out

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current logged-in user
  User? get currentUser => _auth.currentUser;

  // Stream to listen for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // no error
    } on FirebaseAuthException catch (e) {
      return e.message; // return error message
    }
  }

  // Sign in with email and password
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // no error
    } on FirebaseAuthException catch (e) {
      return e.message; // return error message
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
