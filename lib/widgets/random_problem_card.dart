import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class RandomProblems extends StatefulWidget {
  @override
  _RandomProblemsState createState() => _RandomProblemsState();
}

class _RandomProblemsState extends State<RandomProblems> {
  bool isLoading = true;
  List<dynamic> randomProblems = [];

  @override
  void initState() {
    super.initState();
    _fetchRandomProblems();
  }

  Future<void> _fetchRandomProblems() async {
    final url = 'https://alfa-leetcode-api.onrender.com/problems';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Shuffle the problem list to ensure randomness
          randomProblems = List.from(data['problemsetQuestionList']);
          randomProblems.shuffle(Random()); // Shuffle the list of problems
          // Select the first 5 problems from the shuffled list
          randomProblems = randomProblems.take(5).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load random problems');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load random problems')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Random Problems',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(57, 36, 72, 1),
          ),
        ),
        SizedBox(height: 8),
        isLoading
            ? Center(child: CircularProgressIndicator()) 
            : SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: randomProblems.length,
            itemBuilder: (context, index) {
              return ProblemCard(
                title: randomProblems[index]['title'],
                difficulty: randomProblems[index]['difficulty'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProblemCard extends StatelessWidget {
  final String title;
  final String difficulty;

  const ProblemCard({required this.title, required this.difficulty});

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
              'Tags: $difficulty',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Take Action on This Challenge!'),
                        content: const Text(
                          'Choose how you\'d like to tackle this challenge:\n\n'
                          '👉 Solve: Go directly to the challenge\'s LeetCode page.\n\n'
                          '🤝 Collaborate: Create a new issue for team coding.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Open the LeetCode URL
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('launch url!')),
                              );
                            },
                            child: const Text('Solve',style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(57, 36, 72, 0.9)),
                          ),
                          TextButton(
                            onPressed: () {
                              // Trigger the issue creation workflow
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('create issue!')),
                              );
                            },
                            child: const Text('Collaborate', style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(57, 36, 72, 0.9),)
                          ),
                        ],
                      );
                    },
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
