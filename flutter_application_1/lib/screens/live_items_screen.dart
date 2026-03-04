// live_items_screen.dart
// Assignment 3.47 – Handling Errors, Loaders, and Empty States Gracefully

import 'dart:async';
import 'package:flutter/material.dart';

// Simulates fetching items from a data source
Future<List<String>> fetchItems({bool simulateError = false, bool simulateEmpty = false}) async {
  await Future.delayed(const Duration(seconds: 2)); // simulate network delay

  if (simulateError) {
    throw Exception('Failed to load items. Please check your connection.');
  }

  if (simulateEmpty) {
    return [];
  }

  return ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
}

class LiveItemsScreen extends StatefulWidget {
  const LiveItemsScreen({super.key});

  @override
  State<LiveItemsScreen> createState() => _LiveItemsScreenState();
}

class _LiveItemsScreenState extends State<LiveItemsScreen> {
  late Future<List<String>> _itemsFuture;
  bool _simulateError = false;
  bool _simulateEmpty = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    setState(() {
      _itemsFuture = fetchItems(
        simulateError: _simulateError,
        simulateEmpty: _simulateEmpty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Items Viewer')),
      body: Column(
        children: [
          // ── Controls to toggle states ──
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Simulate Error'),
                  selected: _simulateError,
                  onSelected: (val) {
                    setState(() {
                      _simulateError = val;
                      _simulateEmpty = false;
                    });
                    _loadItems();
                  },
                ),
                FilterChip(
                  label: const Text('Simulate Empty'),
                  selected: _simulateEmpty,
                  onSelected: (val) {
                    setState(() {
                      _simulateEmpty = val;
                      _simulateError = false;
                    });
                    _loadItems();
                  },
                ),
              ],
            ),
          ),

          // ── FutureBuilder handles all 3 states ──
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _itemsFuture,
              builder: (context, snapshot) {
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading items...'),
                      ],
                    ),
                  );
                }

                // 2. Error State
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 12),
                        const Text(
                          'Something went wrong.',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString().replaceAll('Exception: ', ''),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _loadItems,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // 3. Empty State
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'No items found.',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap + to add your first item.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // 4. Success State – show items
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(items[index]),
                      subtitle: Text('Loaded successfully'),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadItems,
        tooltip: 'Reload',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
