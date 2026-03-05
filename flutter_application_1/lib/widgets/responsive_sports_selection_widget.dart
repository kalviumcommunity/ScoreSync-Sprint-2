import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// RESPONSIVE SPORTS SELECTION WIDGET
/// Adapts between vertical list, horizontal row, or grid based on screen size
class ResponsiveSportsSelectionWidget extends StatelessWidget {
  final List<String> sports;
  final Function(String) onSportSelected;
  final String selectedSport;

  const ResponsiveSportsSelectionWidget({
    super.key,
    required this.sports,
    required this.onSportSelected,
    required this.selectedSport,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return ResponsiveContainer(
      padding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
      backgroundColor: Colors.grey[100],
      borderRadius: 8.0,
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.0 : 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Sport',
            style: TextStyle(
              fontSize: Responsive.responsiveFontSize(context,
                  mobile: 14, tablet: 16, desktop: 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          ResponsiveSpacer(
            mobileHeight: 8,
            tabletHeight: 12,
            desktopHeight: 16,
          ),
          // Responsive grid/row based on screen size
          if (isMobile)
            // Mobile: Single column scrollable
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  sports.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildSportButton(context, sports[index]),
                  ),
                ),
              ),
            )
          else if (isTablet)
            // Tablet: 2 columns
            ResponsiveGrid(
              mobileColumns: 2,
              tabletColumns: 2,
              desktopColumns: 3,
              spacing: 8,
              children: sports
                  .map((sport) => _buildSportButton(context, sport))
                  .toList(),
            )
          else
            // Desktop: 4+ columns or horizontal row
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: sports
                  .map((sport) => _buildSportButton(context, sport))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSportButton(BuildContext context, String sport) {
    final isSelected = sport == selectedSport;
    final isMobile = Responsive.isMobile(context);

    return Container(
      constraints: BoxConstraints(
        minWidth: isMobile ? 80 : 100,
      ),
      child: ElevatedButton(
        onPressed: () => onSportSelected(sport),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue[600] : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          elevation: isSelected ? 4 : 1,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8.0 : 12.0,
            vertical: isMobile ? 8.0 : 12.0,
          ),
          side: BorderSide(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          sport,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Responsive.responsiveFontSize(context,
                mobile: 11, tablet: 13, desktop: 14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
