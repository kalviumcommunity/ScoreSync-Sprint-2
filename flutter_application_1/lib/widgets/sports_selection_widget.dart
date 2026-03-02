import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// STATELESS WIDGET - Static, immutable widgets for sport selection
/// Used: Display sport buttons that don't change after creation
/// ENHANCED: Now responsive with adaptive layout based on screen size
class SportsSelectionWidget extends StatelessWidget {
  final List<String> sports;
  final Function(String) onSportSelected;
  final String? selectedSport;

  const SportsSelectionWidget({
    super.key,
    required this.sports,
    required this.onSportSelected,
    this.selectedSport,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    // Mobile: Horizontal scrollable
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: sports.map((sport) {
            final isSelected = sport == selectedSport;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                ),
                onPressed: () => onSportSelected(sport),
                child: Text(
                  sport,
                  style: TextStyle(
                    fontSize: Responsive.responsiveFontSize(context,
                        mobile: 11, tablet: 13, desktop: 14),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    // Tablet & Desktop: Grid or responsive wrap
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 8.0 : 16.0,
      ),
      child: Wrap(
        spacing: isTablet ? 8.0 : 16.0,
        runSpacing: 8.0,
        children: sports.map((sport) {
          final isSelected = sport == selectedSport;
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
              foregroundColor: isSelected ? Colors.white : Colors.black,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 12.0 : 20.0,
                vertical: 10.0,
              ),
              elevation: isSelected ? 4 : 1,
            ),
            onPressed: () => onSportSelected(sport),
            child: Text(
              sport,
              style: TextStyle(
                fontSize: Responsive.responsiveFontSize(context,
                    mobile: 12, tablet: 14, desktop: 16),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
