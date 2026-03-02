import 'package:flutter/material.dart';

/// STATEFUL WIDGET - List of upcoming matches
/// Used: Display upcoming fixtures that can be filtered/refreshed
class UpcomingMatchesWidget extends StatefulWidget {
  final String selectedSport;

  const UpcomingMatchesWidget({
    super.key,
    required this.selectedSport,
  });

  @override
  State<UpcomingMatchesWidget> createState() => _UpcomingMatchesWidgetState();
}

class _UpcomingMatchesWidgetState extends State<UpcomingMatchesWidget> {
  final List<Map<String, String>> matches = [
    {
      'team1': 'Team A',
      'team2': 'Team B',
      'date': '2026-03-05',
      'day': 'Thursday',
      'time': '3:00 PM',
    },
    {
      'team1': 'Team C',
      'team2': 'Team D',
      'date': '2026-03-06',
      'day': 'Friday',
      'time': '7:30 PM',
    },
    {
      'team1': 'Team E',
      'team2': 'Team F',
      'date': '2026-03-07',
      'day': 'Saturday',
      'time': '2:00 PM',
    },
  ];

  bool isLoading = false;

  /// Refresh matches list (simulated API call)
  Future<void> refreshMatches() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Matches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                onPressed: isLoading ? null : refreshMatches,
              ),
            ],
          ),
        ),
        // Match List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and Day
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '${match['day']} - ${match['date']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Teams
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            match['team1'] ?? '',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const Text(
                          'VS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            match['team2'] ?? '',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Time
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Time: ${match['time']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
