import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// RESPONSIVE STATEFUL WIDGET - Dynamic score display
/// Adapts layout and spacing based on screen size
class ResponsiveCurrentScoresWidget extends StatefulWidget {
  final String team1;
  final String team2;

  const ResponsiveCurrentScoresWidget({
    super.key,
    required this.team1,
    required this.team2,
  });

  @override
  State<ResponsiveCurrentScoresWidget> createState() =>
      _ResponsiveCurrentScoresWidgetState();
}

class _ResponsiveCurrentScoresWidgetState
    extends State<ResponsiveCurrentScoresWidget> {
  int team1Score = 0;
  int team2Score = 0;
  bool isLoading = false;

  Future<void> refreshScores() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      team1Score = 42;
      team2Score = 38;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshScores();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final screenWidth = Responsive.screenWidth(context);

    return ResponsiveContainer(
      backgroundColor: Colors.white,
      borderRadius: 12.0,
      padding: EdgeInsets.all(isMobile ? 12.0 : isTablet ? 16.0 : 20.0),
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.0 : 16.0,
      ),
      child: Column(
        children: [
          // Responsive main score display
          ResponsiveRow(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            forceColumn: isMobile && screenWidth < 400,
            children: [
              // Team 1
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.team1,
                        style: TextStyle(
                          fontSize: Responsive.responsiveFontSize(context,
                              mobile: 12, tablet: 14, desktop: 16),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ResponsiveSpacer(
                        mobileHeight: 4,
                        tabletHeight: 8,
                        desktopHeight: 12,
                      ),
                      Text(
                        '$team1Score',
                        style: TextStyle(
                          fontSize: Responsive.responsiveFontSize(context,
                              mobile: 32, tablet: 40, desktop: 48),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isMobile || screenWidth >= 400)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8.0 : 12.0,
                  ),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontSize: Responsive.responsiveFontSize(context,
                          mobile: 14, tablet: 18, desktop: 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              // Team 2
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.team2,
                        style: TextStyle(
                          fontSize: Responsive.responsiveFontSize(context,
                              mobile: 12, tablet: 14, desktop: 16),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ResponsiveSpacer(
                        mobileHeight: 4,
                        tabletHeight: 8,
                        desktopHeight: 12,
                      ),
                      Text(
                        '$team2Score',
                        style: TextStyle(
                          fontSize: Responsive.responsiveFontSize(context,
                              mobile: 32, tablet: 40, desktop: 48),
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ResponsiveSpacer(
            mobileHeight: 12,
            tabletHeight: 16,
            desktopHeight: 20,
          ),
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
    );
  }
}
