import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_score_header_widget.dart';
import '../widgets/responsive_current_scores_widget.dart';
import '../widgets/responsive_sports_selection_widget.dart';
import '../widgets/responsive_upcoming_matches_widget.dart';

/// RESPONSIVE HOME PAGE EXAMPLE
/// Demonstrates responsive layouts using Rows, Columns, and Containers
/// Adapts beautifully to mobile, tablet, and desktop screens
class ResponsiveHomePage extends StatefulWidget {
  const ResponsiveHomePage({super.key});

  @override
  State<ResponsiveHomePage> createState() => _ResponsiveHomePageState();
}

class _ResponsiveHomePageState extends State<ResponsiveHomePage> {
  String selectedSport = 'Football';
  final List<String> availableSports = [
    'Football',
    'Basketball',
    'Cricket',
    'Tennis',
    'Badminton',
    'Volleyball',
  ];

  void handleSportSelection(String sport) {
    setState(() {
      selectedSport = sport;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final screenWidth = Responsive.screenWidth(context);

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
              ResponsiveSpacer(
                mobileHeight: 8,
                tabletHeight: 12,
                desktopHeight: 16,
              ),
              // 1. SPORTS SELECTION - Responsive grid/row
              ResponsiveSportsSelectionWidget(
                sports: availableSports,
                onSportSelected: handleSportSelection,
                selectedSport: selectedSport,
              ),
              ResponsiveSpacer(
                mobileHeight: 12,
                tabletHeight: 16,
                desktopHeight: 24,
              ),
              // 2. SCORE HEADER - Responsive text sizing
              ResponsiveScoreHeaderWidget(
                sportName: selectedSport,
                lastUpdated: '5 mins ago',
              ),
              ResponsiveSpacer(
                mobileHeight: 12,
                tabletHeight: 16,
                desktopHeight: 24,
              ),
              // 3. CURRENT SCORES - Responsive layout (row/column)
              ResponsiveCurrentScoresWidget(
                team1: 'Home Team',
                team2: 'Away Team',
              ),
              ResponsiveSpacer(
                mobileHeight: 12,
                tabletHeight: 16,
                desktopHeight: 24,
              ),
              // 4. UPCOMING MATCHES - Responsive grid
              ResponsiveUpcomingMatchesWidget(
                selectedSport: selectedSport,
              ),
              ResponsiveSpacer(
                mobileHeight: 16,
                tabletHeight: 20,
                desktopHeight: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
