import 'package:flutter/material.dart';
import '../widgets/sports_selection_widget.dart';
import '../widgets/score_header_widget.dart';
import '../widgets/current_scores_widget.dart';
import '../widgets/upcoming_matches_widget.dart';

/// EXAMPLE HOME PAGE showing how to use Stateless and Stateful Widgets together
/// This is a complete example of your ScoreSync app layout
class HomePageExample extends StatefulWidget {
  const HomePageExample({super.key});

  @override
  State<HomePageExample> createState() => _HomePageExampleState();
}

class _HomePageExampleState extends State<HomePageExample> {
  String selectedSport = 'Football';
  final List<String> availableSports = [
    'Football',
    'Basketball',
    'Cricket',
    'Tennis',
  ];

  void handleSportSelection(String sport) {
    setState(() {
      selectedSport = sport;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScoreSync'),
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. STATELESS WIDGET - Sport Selection (immutable buttons)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SportsSelectionWidget(
                sports: availableSports,
                onSportSelected: handleSportSelection,
                selectedSport: selectedSport,
              ),
            ),
            // 2. STATELESS WIDGET - Header (static display)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ScoreHeaderWidget(
                sportName: selectedSport,
                lastUpdated: '5 mins ago',
              ),
            ),
            const SizedBox(height: 16),
            // 3. STATEFUL WIDGET - Current Scores (changes over time)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CurrentScoresWidget(
                team1: 'Home Team',
                team2: 'Away Team',
              ),
            ),
            const SizedBox(height: 24),
            // 4. STATEFUL WIDGET - Upcoming Matches (refreshes with new data)
            UpcomingMatchesWidget(
              selectedSport: selectedSport,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
