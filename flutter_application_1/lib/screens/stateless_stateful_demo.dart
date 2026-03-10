import 'package:flutter/material.dart';

class StatelessStatefulDemo extends StatelessWidget {
  const StatelessStatefulDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stateless vs Stateful Demo"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          if (isWide) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(child: HeaderWidget()),
                  const SizedBox(width: 40),
                  const Flexible(child: CounterWidget()),
                ],
              ),
            );
          }

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeaderWidget(),
                SizedBox(height: 30),
                CounterWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ----------------------------
// 1️⃣ Stateless Widget – Animated fade-in on load
// ----------------------------
class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize =
        screenWidth < 360 ? 18.0 : (screenWidth < 600 ? 24.0 : 30.0);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          "Interactive Counter App",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ----------------------------
// 2️⃣ Stateful Widget – Animated counter with bounce & transitions
// ----------------------------
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget>
    with TickerProviderStateMixin {
  int count = 0;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  late AnimationController _entryController;
  late Animation<double> _entryFade;
  late Animation<double> _entryScale;

  @override
  void initState() {
    super.initState();

    // Bounce animation for the counter text on tap
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Entry animation – scale + fade in
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entryFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _entryScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void increment() {
    _bounceController.forward(from: 0.0);
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final countFontSize =
        screenWidth < 360 ? 16.0 : (screenWidth < 600 ? 20.0 : 26.0);

    return FadeTransition(
      opacity: _entryFade,
      child: ScaleTransition(
        scale: _entryScale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated counter with bounce on tap
            ScaleTransition(
              scale: _bounceAnimation,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Text(
                  "Count: $count",
                  key: ValueKey<int>(count),
                  style: TextStyle(fontSize: countFontSize),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: increment,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 600 ? 20 : 32,
                  vertical: screenWidth < 600 ? 12 : 16,
                ),
              ),
              child: const Text("Increase"),
            ),
          ],
        ),
      ),
    );
  }
}