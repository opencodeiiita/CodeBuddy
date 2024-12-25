

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LeetCodeProgressGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.white, // White background for the card
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Problems Solved',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Dark color for text
              ),
            ),
            SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 2,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 8,
                          color: Colors.blue, // DP bar
                          width: 20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 12,
                          color: Colors.green, // BT bar
                          width: 20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 6,
                          color: Colors.red, // GPH bar
                          width: 20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: 15,
                          color: Colors.orange, // DP bar
                          width: 20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: 10,
                          color: Colors.purple, // Math bar
                          width: 20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ],
                  borderData: FlBorderData(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey), // Gray bottom border
                      left: BorderSide(color: Colors.grey), // Gray left border
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,  // Reserved size for the title to avoid overlap
                        getTitlesWidget: (value, meta) {
                          String text = '';
                          Color bgColor = Colors.transparent; // Default color
                          switch (value.toInt()) {
                            case 0:
                              text = 'DP'; // Dynamic Programming
                              bgColor = Colors.blue; // DP bar color
                              break;
                            case 1:
                              text = 'BT'; // Binary Tree
                              bgColor = Colors.green; // BT bar color
                              break;
                            case 2:
                              text = 'GPH'; // Graphs
                              bgColor = Colors.red; // GPH bar color
                              break;
                            case 3:
                              text = 'SQ'; // Dynamic Programming
                              bgColor = Colors.orange; // DP bar color
                              break;
                            case 4:
                              text = 'Math'; // Math
                              bgColor = Colors.purple; // Math bar color
                              break;
                          }

                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),  // Increased padding to move it down
                            decoration: BoxDecoration(
                              color: bgColor, // Set color to match bar
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              text,
                              style: TextStyle(
                                color: Colors.white, // White text for better contrast
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

