import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DifficultySelection extends StatefulWidget {
  @override
  _DifficultySelectionState createState() => _DifficultySelectionState();
}

class _DifficultySelectionState extends State<DifficultySelection> {
  String selectedDifficulty = 'Easy';
  Map<String, List<Map<String, String>>> problemsByDifficulty = {
    'Easy': [],
    'Medium': [],
    'Hard': []
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProblems();
  }

  Future<void> fetchProblems() async {
    const apiUrl = 'https://alfa-leetcode-api.onrender.com/problems';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> problemList = data['problemsetQuestionList'];

        // Categorize and limit problems by difficulty
        Map<String, List<Map<String, String>>> categorizedProblems = {
          'Easy': [],
          'Medium': [],
          'Hard': []
        };

        for (var problem in problemList) {
          final difficulty = problem['difficulty'];
          final currentList = categorizedProblems[difficulty] as List<Map<String, String>>?;
          categorizedProblems[difficulty]?.add({
            'title': problem['title'],
            'description': problem['titleSlug'],
          });
        }

        setState(() {
          problemsByDifficulty = categorizedProblems;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load problems');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching problems: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentProblems = problemsByDifficulty[selectedDifficulty];

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New container for "Select Difficulty" text and dropdown
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromRGBO(150, 123, 182, 0.2), // Light purple background
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color.fromRGBO(150, 123, 182, 1), // Purple outline
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Difficulty',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(57, 36, 72, 1),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(57, 36, 72, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedDifficulty,
                    dropdownColor: Color.fromRGBO(57, 36, 72, 1),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    items: problemsByDifficulty.keys.map((difficulty) {
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
          ),
          SizedBox(height: 16),
          currentProblems != null && currentProblems.isNotEmpty
              ? SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentProblems.length,
              itemBuilder: (context, index) {
                final problem = currentProblems[index];
                return ProblemCard(
                  title: problem['title']!,
                  description: problem['description']!,
                );
              },
            ),
          )
              : Text(
            'No problems available for this difficulty.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ProblemCard extends StatelessWidget {
  final String title;
  final String description;

  ProblemCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Color.fromRGBO(57, 36, 72, 0.9),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              'Description: $description',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Navigate to solve the problem!')),
                  );
                },
                child: Text(
                  'Solve Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(57, 36, 72, 1),
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
