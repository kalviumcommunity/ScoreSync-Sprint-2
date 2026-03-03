import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Signup failed";
    }
  }

  // Login
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed";
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Auth state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  /// Build a responsive widget using MediaQuery and LayoutBuilder
  /// This function demonstrates responsive design patterns for UI adaptation
  /// 
  /// Parameters:
  /// - context: BuildContext for MediaQuery access
  /// - mobileBuild: Widget to display on mobile devices (width < 600)
  /// - tabletBuild: Widget to display on tablet devices (600 <= width < 900)
  /// - desktopBuild: Widget to display on desktop devices (width >= 900)
  /// 
  /// Returns: A responsive widget based on screen size
  /// 
  /// Example usage:
  /// ```dart
  /// buildResponsiveWidget(
  ///   context,
  ///   mobileBuild: (context, constraints) => MobileLayout(),
  ///   tabletBuild: (context, constraints) => TabletLayout(),
  ///   desktopBuild: (context, constraints) => DesktopLayout(),
  /// )
  /// ```
  Widget buildResponsiveWidget(
    BuildContext context, {
    required Widget Function(BuildContext, BoxConstraints) mobileBuild,
    required Widget Function(BuildContext, BoxConstraints) tabletBuild,
    required Widget Function(BuildContext, BoxConstraints) desktopBuild,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        // Determine device type based on screen width
        if (screenWidth < 600) {
          // Mobile device
          return mobileBuild(context, constraints);
        } else if (screenWidth < 900) {
          // Tablet device
          return tabletBuild(context, constraints);
        } else {
          // Desktop device
          return desktopBuild(context, constraints);
        }
      },
    );
  }

  /// Get responsive dimensions based on current screen size
  /// 
  /// Uses MediaQuery to determine optimal dimensions for responsive layouts
  /// 
  /// Returns a map containing responsive dimension values
  Map<String, double> getResponsiveDimensions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    late double containerWidth;
    late double containerHeight;
    late double padding;
    late double fontSize;
    late int crossAxisCount;

    if (screenWidth < 600) {
      // Mobile
      containerWidth = screenWidth * 0.9;
      containerHeight = screenHeight * 0.6;
      padding = 12.0;
      fontSize = 14.0;
      crossAxisCount = 1;
    } else if (screenWidth < 900) {
      // Tablet
      containerWidth = screenWidth * 0.85;
      containerHeight = screenHeight * 0.7;
      padding = 16.0;
      fontSize = 16.0;
      crossAxisCount = 2;
    } else {
      // Desktop
      containerWidth = 1000.0; // Fixed max width
      containerHeight = screenHeight * 0.8;
      padding = 24.0;
      fontSize = 18.0;
      crossAxisCount = 3;
    }

    return {
      'containerWidth': containerWidth,
      'containerHeight': containerHeight,
      'padding': padding,
      'fontSize': fontSize,
      'crossAxisCount': crossAxisCount.toDouble(),
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
    };
  }

  /// Build an auth form with responsive layout
  /// 
  /// Adapts form layout based on screen size using MediaQuery and LayoutBuilder
  /// Uses LayoutBuilder to constrain child widgets based on available space
  /// 
  /// Returns: A responsive form widget
  Widget buildResponsiveAuthForm(
    BuildContext context, {
    required Widget Function(BoxConstraints) formBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final isSmallScreen = screenWidth < 600;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : 32.0,
                  vertical: isSmallScreen ? 16.0 : 24.0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isSmallScreen ? double.infinity : 500.0,
                    ),
                    child: formBuilder(constraints),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}