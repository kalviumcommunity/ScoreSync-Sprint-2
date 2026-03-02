import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// STATEFUL WIDGET - List of upcoming matches
/// Used: Display upcoming fixtures that can be filtered/refreshed
/// ENHANCED: Now responsive with adaptive grid/list layout
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
    {
      'team1': 'Team G',
      'team2': 'Team H',
      'date': '2026-03-08',
      'day': 'Sunday',
      'time': '5:00 PM',
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
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8.0 : 16.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Matches',
                style: TextStyle(
                  fontSize: Responsive.responsiveFontSize(context,
                      mobile: 16, tablet: 18, desktop: 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue[600]!,
                          ),
                        ),
                      )
                    : Icon(Icons.refresh, color: Colors.blue[600]),
                onPressed: isLoading ? null : refreshMatches,
              ),
            ],
          ),
        ),
        // Match List/Grid - Responsive layout
        if (isMobile)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return _buildMatchCard(context, matches[index]);
            },
          )
        else if (isTablet)
          ResponsiveGrid(
            tabletColumns: 2,
            spacing: 12,
            children: matches.map((match) => _buildMatchCard(context, match)).toList(),
          )
        else
          ResponsiveGrid(
            desktopColumns: 4,
            spacing: 16,
            children: matches.map((match) => _buildMatchCard(context, match)).toList(),
          ),
      ],
    );
  }

  Widget _buildMatchCard(BuildContext context, Map<String, String> match) {
    final isMobile = Responsive.isMobile(context);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.0 : 0,
        vertical: 8.0,
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Day
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${match['day']} - ${match['date']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.responsiveFontSize(context,
                      mobile: 11, tablet: 12, desktop: 13),
                  color: Colors.blue[800],
                ),
              ),
            ),
            SizedBox(height: isMobile ? 8 : 12),
            // Teams
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    match['team1'] ?? '',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFontSize(context,
                          mobile: 12, tablet: 13, desktop: 14),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: Responsive.responsiveFontSize(context,
                          mobile: 10, tablet: 11, desktop: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    match['team2'] ?? '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: Responsive.responsiveFontSize(context,
                          mobile: 12, tablet: 13, desktop: 14),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 12),
            // Time
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '🕐 ${match['time']}',
                style: TextStyle(
                  fontSize: Responsive.responsiveFontSize(context,
                      mobile: 11, tablet: 12, desktop: 13),
                  color: Colors.orange[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive grid widget helper
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double mobileColumns;
  final double tabletColumns;
  final double desktopColumns;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    late double columns;

    if (Responsive.isDesktop(context)) {
      columns = desktopColumns;
    } else if (Responsive.isTablet(context)) {
      columns = tabletColumns;
    } else {
      columns = mobileColumns;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns.toInt(),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
