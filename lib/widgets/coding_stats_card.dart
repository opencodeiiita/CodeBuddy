//  Version 1
import 'package:flutter/material.dart';
import 'dart:math';


class CodingStatsCard extends StatelessWidget {
  final int submissions;
  final int challengesCompleted;
  final List<String> codingLanguages;

  CodingStatsCard({
    required this.submissions,
    required this.challengesCompleted,
    required this.codingLanguages,
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
            "Coding Stats",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatItem(
                icon: Icons.task_alt,
                label: "Submissions",
                value: submissions.toString(),
              ),
              StatItem(
                icon: Icons.check_circle,
                label: "Challenges",
                value: challengesCompleted.toString(),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "Coding Languages",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: codingLanguages.map((lang) {
              // Generate random light background color
              final randomColor = Color.fromARGB(
                255,
                200 + Random().nextInt(55), // Red component (lighter range)
                200 + Random().nextInt(55), // Green component (lighter range)
                200 + Random().nextInt(55), // Blue component (lighter range)
              );

              return Chip(
                label: Text(
                  lang,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Text color for contrast
                  ),
                ),
                backgroundColor: randomColor, // Light random background color
                shape: StadiumBorder(
                  side: BorderSide(
                    color: Colors.black26, // Stroke outline color
                    width: 1.0,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text(
            "Challenge Progress",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: challengesCompleted / 100, // Example progress
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  StatItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blueAccent),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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

