import 'package:flutter/material.dart';

class DifficultySelection extends StatefulWidget {
  @override
  _DifficultySelectionState createState() => _DifficultySelectionState();
}

class _DifficultySelectionState extends State<DifficultySelection> {
  String selectedDifficulty = 'Easy'; // Default selected difficulty
  final Map<String, Map<String, String>> problems = {
    'Easy': {'title': 'Sum of Two Numbers', 'description': 'Solve a simple sum of two numbers.'},
    'Medium': {'title': 'Find Prime Numbers', 'description': 'Identify all prime numbers in a range.'},
    'Hard': {'title': 'Graph Shortest Path', 'description': 'Find the shortest path in a weighted graph.'},
  };

  @override
  Widget build(BuildContext context) {
    final problem = problems[selectedDifficulty]!;

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Difficulty',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedDifficulty,
                  dropdownColor: Color.fromRGBO(57, 36, 72, 1),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  items: problems.keys.map((difficulty) {
                    return DropdownMenuItem(
                      value: difficulty,
                      child: Text(
                        difficulty,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDifficulty = value!;
                    });
                  },
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Problem Title:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(57, 36, 72, 1),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  problem['title']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(57, 36, 72, 1),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  problem['description']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                      },
                      child: Text(
                        'Solve Now',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
