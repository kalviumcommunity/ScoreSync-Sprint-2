// quick_tabs_screen.dart
// Assignment 3.45 – Designing App Navigation Flow Using BottomNavigationBar

import 'package:flutter/material.dart';

// ── Individual Tab Screens ──

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 60, color: Colors.blue),
          SizedBox(height: 12),
          Text('Home', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Welcome to the Home tab!', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ExploreTab extends StatelessWidget {
  const _ExploreTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.explore, size: 60, color: Colors.orange),
          const SizedBox(height: 12),
          const Text('Explore', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Discover new content here.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(6, (i) {
              return Chip(
                label: Text('Topic ${i + 1}'),
                backgroundColor: Colors.orange[100],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          SizedBox(height: 12),
          Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('PKVH', style: TextStyle(fontSize: 16)),
          Text('Flutter Developer', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── Main Screen with BottomNavigationBar ──

class QuickTabsScreen extends StatefulWidget {
  const QuickTabsScreen({super.key});

  @override
  State<QuickTabsScreen> createState() => _QuickTabsScreenState();
}

class _QuickTabsScreenState extends State<QuickTabsScreen> {
  int _currentIndex = 0;

  // IndexedStack keeps each tab alive — state is preserved on tab switch
  final List<Widget> _screens = const [
    _HomeTab(),
    _ExploreTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuickTabs Navigation')),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
