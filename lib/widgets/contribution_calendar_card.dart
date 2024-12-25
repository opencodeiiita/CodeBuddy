
import 'package:flutter/material.dart';

class ContributionCalendarCard extends StatelessWidget {
  final List<List<int>> contributionsData; // List of 12 lists, each containing 30 days of contributions

  ContributionCalendarCard({required this.contributionsData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title "Activity Heatmap"
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Activity Heatmap',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(57, 36, 72, 1),
            ),
          ),
        ),
        // Heatmap Card
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(57, 36, 72, 1),
                Color.fromRGBO(57, 36, 72, 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scrollable horizontal list of 12 matrices
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(12, (index) {
                    // Generate the matrix for each month's contributions
                    List<int> monthContributions = contributionsData[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0), // Space between matrices
                      child: Column(
                        children: [
                          _buildMatrix(monthContributions),
                          // Add the month label row below the matrix
                          _buildMonthLabels(index),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper function to generate a matrix for the contributions
  Widget _buildMatrix(List<int> contributions) {
    List<Widget> rows = [];
    for (int i = 0; i < 5; i++) {
      int startIndex = i * 6;
      int endIndex = startIndex + 6;

      List<int> rowContributions = contributions.sublist(startIndex, endIndex);
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rowContributions.map((contribution) {
          Color color = _getColorForContributions(contribution);
          return Tooltip(
            message: '$contribution contributions',
            child: Container(
              margin: EdgeInsets.all(2),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }).toList(),
      ));
    }
    return Column(
      children: rows,
    );
  }

  // Helper function to generate the month labels below each matrix
  Widget _buildMonthLabels(int index) {
    List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    String monthLabel = months[index];

    return Padding(
      padding: const EdgeInsets.only(top: 8.0), // Padding between matrix and month label
      child: Text(
        monthLabel,
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }

  // Function to determine the color based on the number of contributions
  Color _getColorForContributions(int contributions) {
    if (contributions == 0) return Colors.grey[300]!;  // No contributions
    if (contributions <= 5) return Colors.green[100]!;  // Light activity
    if (contributions <= 10) return Colors.green[300]!;  // Moderate activity
    if (contributions <= 20) return Colors.green[500]!;  // High activity
    return Colors.green[700]!;  // Very high activity
  }
}
