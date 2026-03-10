import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/sports_selection_widget.dart';
import '../widgets/score_header_widget.dart';
import '../widgets/current_scores_widget.dart';
import '../widgets/upcoming_matches_widget.dart';

/// ENHANCED HOME PAGE with responsive layouts
/// Demonstrates how to use Stateless and Stateful Widgets together
/// with responsive design principles using Rows, Columns, and Containers
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
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ScoreSync',
          style: TextStyle(
            fontSize: Responsive.responsiveFontSize(context,
                mobile: 18, tablet: 20, desktop: 24),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 2,
        centerTitle: isMobile,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              // 1. STATELESS WIDGET - Sport Selection (immutable buttons)
              // Uses responsive layout that adapts to screen size
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 0 : 16.0,
                ),
                child: SportsSelectionWidget(
                  sports: availableSports,
                  onSportSelected: handleSportSelection,
                  selectedSport: selectedSport,
                ),
              ),
              SizedBox(
                height: isMobile ? 12 : 16,
              ),
              // 2. STATELESS WIDGET - Header (static display)
              // Responsive padding and font sizes
              ScoreHeaderWidget(
                sportName: selectedSport,
                lastUpdated: '5 mins ago',
              ),
              SizedBox(
                height: isMobile ? 12 : 16,
              ),
              // 3. STATEFUL WIDGET - Current Scores (changes over time)
              // Responsive layout switches from Row to Column on small screens
              CurrentScoresWidget(
                team1: 'Home Team',
                team2: 'Away Team',
              ),
              SizedBox(
                height: isMobile ? 12 : 24,
              ),
              // 4. STATEFUL WIDGET - Upcoming Matches (refreshes with new data)
              // Responsive grid that shows list on mobile, grid on tablet+
              UpcomingMatchesWidget(
                selectedSport: selectedSport,
              ),
              SizedBox(
                height: isMobile ? 16 : 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
