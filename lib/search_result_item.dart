import 'package:flutter/material.dart';
import 'package:codebuddy/problem.dart';

class SearchResultItem extends StatelessWidget {
  final Problem result;

  const SearchResultItem({required this.result});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.question_answer, color: Colors.blue),
      title: Text(result.title), // Display title of the problem
      subtitle: Text(
        'Difficulty: ${result.difficulty}\nAcceptance Rate: ${result.acRate.toStringAsFixed(2)}%',
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
