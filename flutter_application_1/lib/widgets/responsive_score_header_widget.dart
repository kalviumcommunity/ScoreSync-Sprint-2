import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// RESPONSIVE STATELESS WIDGET - Dynamic header for score display
/// Adapts layout and sizing based on screen dimensions
class ResponsiveScoreHeaderWidget extends StatelessWidget {
  final String sportName;
  final String lastUpdated;

  const ResponsiveScoreHeaderWidget({
    super.key,
    required this.sportName,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return ResponsiveContainer(
      backgroundColor: Colors.blue[600],
      borderRadius: 8.0,
      padding: EdgeInsets.all(isMobile ? 12.0 : isTablet ? 16.0 : 20.0),
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.0 : 16.0,
        vertical: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sport name with responsive font
          Text(
            sportName,
            style: TextStyle(
              fontSize: Responsive.responsiveFontSize(context,
                  mobile: 20, tablet: 24, desktop: 28),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          ResponsiveSpacer(
            mobileHeight: 4,
            tabletHeight: 8,
            desktopHeight: 12,
          ),
          // Last updated with responsive font
          Text(
            'Last Updated: $lastUpdated',
            style: TextStyle(
              fontSize: Responsive.responsiveFontSize(context,
                  mobile: 10, tablet: 12, desktop: 14),
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
