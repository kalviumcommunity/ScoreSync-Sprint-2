import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// STATELESS WIDGET - Static header for score display
/// Used: Shows sport name and last update time (immutable data)
/// ENHANCED: Now responsive with adaptive font sizes and padding
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
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.0 : 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sportName,
            style: TextStyle(
              fontSize: Responsive.responsiveFontSize(context,
                  mobile: 20, tablet: 24, desktop: 28),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
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
