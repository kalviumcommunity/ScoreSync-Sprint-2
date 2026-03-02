import 'package:flutter/material.dart';

/// STATELESS WIDGET - Static, immutable widgets for sport selection
/// Used: Display sport buttons that don't change after creation
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sports.map((sport) {
          final isSelected = sport == selectedSport;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? Colors.blue : Colors.grey[300],
                foregroundColor: isSelected ? Colors.white : Colors.black,
              ),
              onPressed: () => onSportSelected(sport),
              child: Text(sport),
            ),
          );
        }).toList(),
      ),
    );
  }
}
