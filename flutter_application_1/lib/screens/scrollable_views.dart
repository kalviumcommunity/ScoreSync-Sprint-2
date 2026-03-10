// scrollable_views.dart
// Assignment 3.18 – Building Scrollable Views with ListView and GridView

import 'package:flutter/material.dart';

class ScrollableViews extends StatelessWidget {
  const ScrollableViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scrollable Views')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── ListView Section ──
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'ListView Example',
                style: TextStyle(fontSize: 18),
              ),
            ),

            // Horizontal scrolling ListView
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.all(8),
                    color: Colors.teal[100 * (index + 2)],
                    child: Center(child: Text('Card $index')),
                  );
                },
              ),
            ),

            // Vertical ListView
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('User ${index + 1}'),
                  subtitle: Text(index % 2 == 0 ? 'Online' : 'Offline'),
                );
              },
            ),

            const Divider(thickness: 2),

            // ── GridView Section ──
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'GridView Example',
                style: TextStyle(fontSize: 18),
              ),
            ),

            SizedBox(
              height: 400,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(
                      child: Text(
                        'Tile $index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
