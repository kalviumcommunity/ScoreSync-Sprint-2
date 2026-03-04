// animations_screen.dart
// Demonstrates implicit animations, explicit animations, and page transitions

import 'package:flutter/material.dart';

class AnimationsScreen extends StatefulWidget {
  const AnimationsScreen({super.key});

  @override
  State<AnimationsScreen> createState() => _AnimationsScreenState();
}

class _AnimationsScreenState extends State<AnimationsScreen>
    with SingleTickerProviderStateMixin {
  // Implicit animation state
  bool _toggled = false;

  // Explicit animation controller (rotation)
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations & Transitions'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // ── Section 1: AnimatedContainer ──
            const Text(
              '1. AnimatedContainer (Implicit)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Tap the button — box changes size & color smoothly',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Center(
              child: AnimatedContainer(
                width: _toggled ? 200 : 100,
                height: _toggled ? 100 : 200,
                decoration: BoxDecoration(
                  color: _toggled ? Colors.teal : Colors.orange,
                  borderRadius: BorderRadius.circular(_toggled ? 40 : 8),
                ),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                child: const Center(
                  child: Text(
                    'Tap Me!',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => setState(() => _toggled = !_toggled),
              child: Text(_toggled ? 'Reset' : 'Animate'),
            ),

            const Divider(height: 40, thickness: 2),

            // ── Section 2: AnimatedOpacity ──
            const Text(
              '2. AnimatedOpacity (Implicit)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Same button fades the icon in/out',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            AnimatedOpacity(
              opacity: _toggled ? 1.0 : 0.1,
              duration: const Duration(milliseconds: 700),
              child: const Icon(Icons.flutter_dash, size: 80, color: Colors.blue),
            ),

            const Divider(height: 40, thickness: 2),

            // ── Section 3: Explicit Rotation ──
            const Text(
              '3. RotationTransition (Explicit)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Auto-rotates using AnimationController',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            RotationTransition(
              turns: _controller,
              child: const Icon(Icons.star, size: 80, color: Colors.amber),
            ),

            const Divider(height: 40, thickness: 2),

            // ── Section 4: Page Transition ──
            const Text(
              '4. Slide Page Transition',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Navigates with a smooth slide animation',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Open Slide Page'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 700),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const _SlidePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Simple destination page for the slide transition demo
class _SlidePage extends StatelessWidget {
  const _SlidePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slide Page'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 16),
            Text(
              'Slide transition works!',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
