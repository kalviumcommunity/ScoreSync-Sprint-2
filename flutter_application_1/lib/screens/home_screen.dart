// home_screen.dart
// Simple Home Screen for multi-screen navigation demo

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Home Screen!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap below to go to the Details screen.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Navigate using pushNamed
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Go to Details Screen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: 'Hello from Home Screen!',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
