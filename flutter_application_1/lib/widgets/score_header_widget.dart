import 'package:flutter/material.dart';

/// STATELESS WIDGET - Static header for score display
/// Used: Shows sport name and last update time (immutable data)
class ScoreHeaderWidget extends StatelessWidget {
  final String sportName;
  final String lastUpdated;

  const ScoreHeaderWidget({
    super.key,
    required this.sportName,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sportName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Last Updated: $lastUpdated',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
