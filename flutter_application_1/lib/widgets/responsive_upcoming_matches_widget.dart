import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// RESPONSIVE UPCOMING MATCHES WIDGET
/// Adapts match card layout between list and grid based on screen size
class ResponsiveUpcomingMatchesWidget extends StatefulWidget {
  final String selectedSport;

  const ResponsiveUpcomingMatchesWidget({
    super.key,
    required this.selectedSport,
  });

  @override
  State<ResponsiveUpcomingMatchesWidget> createState() =>
      _ResponsiveUpcomingMatchesWidgetState();
}

class _ResponsiveUpcomingMatchesWidgetState
    extends State<ResponsiveUpcomingMatchesWidget> {
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

  Future<void> refreshMatches() async {
    setState(() {
      isLoading = true;
    });
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

    return ResponsiveContainer(
      padding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.0 : 16.0,
        vertical: 12.0,
      ),
      backgroundColor: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and refresh button
          Row(
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
          ResponsiveSpacer(
            mobileHeight: 8,
            tabletHeight: 12,
            desktopHeight: 16,
          ),
          // Responsive match grid/list
          if (isMobile)
            // Mobile: Single column list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matches.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildMatchCard(context, matches[index]),
              ),
            )
          else if (isTablet)
            // Tablet: 2 columns grid
            ResponsiveGrid(
              mobileColumns: 1,
              tabletColumns: 2,
              desktopColumns: 2,
              spacing: 12,
              children: matches
                  .map((match) => _buildMatchCard(context, match))
                  .toList(),
            )
          else
            // Desktop: 3-4 columns grid
            ResponsiveGrid(
              mobileColumns: 1,
              tabletColumns: 2,
              desktopColumns: 4,
              spacing: 16,
              children: matches
                  .map((match) => _buildMatchCard(context, match))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, Map<String, String> match) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and day
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
                fontSize: Responsive.responsiveFontSize(context,
                    mobile: 10, tablet: 11, desktop: 12),
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
          ),
          ResponsiveSpacer(
            mobileHeight: 8,
            tabletHeight: 10,
            desktopHeight: 12,
          ),
          // Teams vs layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Team 1
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match['team1']!,
                      style: TextStyle(
                        fontSize: Responsive.responsiveFontSize(context,
                            mobile: 11, tablet: 12, desktop: 13),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // VS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'vs',
                  style: TextStyle(
                    fontSize: Responsive.responsiveFontSize(context,
                        mobile: 10, tablet: 11, desktop: 12),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              // Team 2
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      match['team2']!,
                      style: TextStyle(
                        fontSize: Responsive.responsiveFontSize(context,
                            mobile: 11, tablet: 12, desktop: 13),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ResponsiveSpacer(
            mobileHeight: 8,
            tabletHeight: 10,
            desktopHeight: 12,
          ),
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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.responsiveFontSize(context,
                    mobile: 11, tablet: 12, desktop: 13),
                fontWeight: FontWeight.w600,
                color: Colors.orange[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
