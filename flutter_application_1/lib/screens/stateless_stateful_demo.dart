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
            // Side-by-side layout for tablets / wide screens
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

          // Stacked layout for phones / narrow screens
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
// 1️⃣ Stateless Widget – Responsive font
// ----------------------------
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 360 ? 18.0 : (screenWidth < 600 ? 24.0 : 30.0);

    return Text(
      "Interactive Counter App",
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// ----------------------------
// 2️⃣ Stateful Widget – Responsive sizing
// ----------------------------
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final countFontSize = screenWidth < 360 ? 16.0 : (screenWidth < 600 ? 20.0 : 26.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Count: $count",
          style: TextStyle(fontSize: countFontSize),
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
    );
  }
}