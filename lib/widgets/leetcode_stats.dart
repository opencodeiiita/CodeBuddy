import 'package:flutter/material.dart';

// LeetCodeStatsCard - Custom widget to display LeetCode stats
class LeetCodeStatsCard extends StatelessWidget {
  final int totalSolved;
  final int totalProblems;
  final int easySolved;
  final int easyTotal;
  final int mediumSolved;
  final int mediumTotal;
  final int hardSolved;
  final int hardTotal;

  LeetCodeStatsCard({
    required this.totalSolved,
    required this.totalProblems,
    required this.easySolved,
    required this.easyTotal,
    required this.mediumSolved,
    required this.mediumTotal,
    required this.hardSolved,
    required this.hardTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "LeetCode Stats",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          // Total Solved Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatItem(
                label: "Total Solved",
                value: "$totalSolved/$totalProblems",
                valueColor: Colors.blueAccent,
              ),
            ],
          ),
          SizedBox(height: 16),
          // Easy, Medium, Hard Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DifficultyStatItem(
                label: "Easy",
                solved: easySolved,
                total: easyTotal,
                color: Colors.green,
              ),
              DifficultyStatItem(
                label: "Medium",
                solved: mediumSolved,
                total: mediumTotal,
                color: Colors.orange,
              ),
              DifficultyStatItem(
                label: "Hard",
                solved: hardSolved,
                total: hardTotal,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// StatItem - Custom widget for displaying label and value
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  StatItem({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

// DifficultyStatItem - Custom widget to display individual difficulty stats
class DifficultyStatItem extends StatelessWidget {
  final String label;
  final int solved;
  final int total;
  final Color color;

  DifficultyStatItem({
    required this.label,
    required this.solved,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = solved / total;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Text(
              "$solved/$total",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }
}
