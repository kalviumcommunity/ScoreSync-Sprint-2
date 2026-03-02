import 'package:flutter/material.dart';

/// STATEFUL WIDGET - Dynamic score counter that updates
/// Used: Display live scores that can be refreshed or updated
class CurrentScoresWidget extends StatefulWidget {
  final String team1;
  final String team2;

  const CurrentScoresWidget({
    super.key,
    required this.team1,
    required this.team2,
  });

  @override
  State<CurrentScoresWidget> createState() => _CurrentScoresWidgetState();
}

class _CurrentScoresWidgetState extends State<CurrentScoresWidget> {
  int team1Score = 0;
  int team2Score = 0;
  bool isLoading = false;

  /// Simulate fetching live score data
  Future<void> refreshScores() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      team1Score = 42; // Replace with real API data
      team2Score = 38;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial scores when widget is created
    refreshScores();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Team 1
                Column(
                  children: [
                    Text(
                      widget.team1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$team1Score',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                // VS
                const Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                // Team 2
                Column(
                  children: [
                    Text(
                      widget.team2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$team2Score',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Refresh button
            ElevatedButton.icon(
              onPressed: isLoading ? null : refreshScores,
              icon: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(isLoading ? 'Refreshing...' : 'Refresh Scores'),
            ),
          ],
        ),
      ),
    );
  }
}
