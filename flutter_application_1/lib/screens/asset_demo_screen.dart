// asset_demo_screen.dart
// Demonstrates local images, built-in icons, and asset management in Flutter

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AssetDemoScreen extends StatelessWidget {
  const AssetDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets Demo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // ── Section 1: Local Image ──
            const Text(
              '📁 Local Image (Image.asset)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Image.asset(
              'assets/images/image-1.png',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 24),

            // ── Section 2: Background Image Container ──
            const Text(
              '🖼️ Background Image (AssetImage)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image-2.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Welcome to Flutter!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Section 3: Material Icons ──
            const Text(
              '🎨 Built-in Material Icons',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Icon(Icons.star, color: Colors.amber, size: 36),
                  Text('Star'),
                ]),
                SizedBox(width: 24),
                Column(children: [
                  Icon(Icons.android, color: Colors.green, size: 36),
                  Text('Android'),
                ]),
                SizedBox(width: 24),
                Column(children: [
                  Icon(Icons.apple, color: Colors.grey, size: 36),
                  Text('Apple'),
                ]),
                SizedBox(width: 24),
                Column(children: [
                  Icon(Icons.flutter_dash, color: Colors.blue, size: 36),
                  Text('Flutter'),
                ]),
              ],
            ),

            const SizedBox(height: 24),

            // ── Section 4: Cupertino Icons ──
            const Text(
              '🍎 Cupertino Icons (iOS Style)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Icon(CupertinoIcons.heart, color: Colors.red, size: 36),
                  Text('Heart'),
                ]),
                SizedBox(width: 24),
                Column(children: [
                  Icon(CupertinoIcons.star, color: Colors.orange, size: 36),
                  Text('Star'),
                ]),
                SizedBox(width: 24),
                Column(children: [
                  Icon(CupertinoIcons.person, color: Colors.teal, size: 36),
                  Text('Person'),
                ]),
              ],
            ),

            const SizedBox(height: 32),

            // ── Section 5: pubspec.yaml info card ──
            Card(
              color: Colors.teal.shade50,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'pubspec.yaml configuration:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text('flutter:\n  assets:\n    - assets/images/\n    - assets/icons/'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}