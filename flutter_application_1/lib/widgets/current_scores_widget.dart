import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// STATEFUL WIDGET - Dynamic score counter that updates
/// Used: Display live scores that can be refreshed or updated
/// ENHANCED: Now responsive with adaptive layouts and sizing
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
    final isMobile = Responsive.isMobile(context);
    final screenWidth = Responsive.screenWidth(context);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.0 : 16.0,
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
        child: Column(
          children: [
            // Responsive score display - Row on desktop, Column on small mobile
            if (isMobile && screenWidth < 400)
              Column(
                children: [
                  _buildTeamScore(context, widget.team1, team1Score, Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'VS',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFontSize(context,
                          mobile: 14, tablet: 16, desktop: 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTeamScore(context, widget.team2, team2Score, Colors.red),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Team 1
                  _buildTeamScore(context, widget.team1, team1Score, Colors.blue),
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
                  _buildTeamScore(context, widget.team2, team2Score, Colors.red),
                ],
              ),
            SizedBox(height: isMobile ? 12.0 : 20.0),
            // Refresh button
            SizedBox(
              width: isMobile ? double.infinity : 200,
              child: ElevatedButton.icon(
                icon: isLoading
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue[600]!,
                          ),
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(
                  isLoading ? 'Refreshing...' : 'Refresh Scores',
                  style: TextStyle(
                    fontSize: Responsive.responsiveFontSize(context,
                        mobile: 12, tablet: 14, desktop: 16),
                  ),
                ),
                onPressed: isLoading ? null : refreshScores,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16.0 : 24.0,
                    vertical: isMobile ? 12.0 : 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamScore(BuildContext context, String teamName, int score,
      Color scoreColor) {
    return Column(
      children: [
        Text(
          teamName,
          style: TextStyle(
            fontSize: Responsive.responsiveFontSize(context,
                mobile: 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: Responsive.isMobile(context) ? 8 : 12,
        ),
        Text(
          '$score',
          style: TextStyle(
            fontSize: Responsive.responsiveFontSize(context,
                mobile: 36, tablet: 42, desktop: 48),
            fontWeight: FontWeight.bold,
            color: scoreColor,
          ),
        ),
      ],
    );
  }
}
