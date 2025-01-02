import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionOfTheDay extends StatefulWidget {
  @override
  _QuestionOfTheDayState createState() => _QuestionOfTheDayState();
}

class _QuestionOfTheDayState extends State<QuestionOfTheDay> {
  String questionTitle = '';
  String questionDifficulty = '';
  String questionCategory = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestionOfTheDay();
  }

  Future<void> _fetchQuestionOfTheDay() async {
    final url = 'https://alfa-leetcode-api.onrender.com/daily';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          questionTitle = data['questionTitle'];
          questionDifficulty = data['difficulty'];
          questionCategory = 'Algorithms'; // Assuming category is 'Algorithms' for now
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load question of the day');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF49AB6C).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF49AB6C), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question of the Day',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF49AB6C),
            ),
          ),
          SizedBox(height: 8),
          isLoading
              ? CircularProgressIndicator()
              : Text(
            'Category: $questionCategory | Difficulty: $questionDifficulty',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          isLoading
              ? Container()
              : Text(
            '“$questionTitle”',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
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
                  backgroundColor: Color(0xFF49AB6C),
                ),
                onPressed: () {},
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
    );
  }
}
