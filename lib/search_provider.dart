import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Problem {
  final String title;
  final double acRate;
  final String difficulty;
  final List<String> topicTags;
  final String questionFrontendId;

  Problem({
    required this.title,
    required this.acRate,
    required this.difficulty,
    required this.topicTags,
    required this.questionFrontendId,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      title: json['title'],
      acRate: json['acRate'],
      difficulty: json['difficulty'],
      topicTags: (json['topicTags'] as List<dynamic>)
          .map((tag) => tag['name'] as String)
          .toList(),
      questionFrontendId: json['questionFrontendId'],
    );
  }
}

class SearchProvider with ChangeNotifier {
  List<Problem> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Problem> get results => _results;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchResults(String query) async {
    if (query.isEmpty) return;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Construct the URL with the user-provided query
      final url = 'https://alfa-leetcode-api.onrender.com/problems?tags=$query';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          _results = data.map((problemJson) => Problem.fromJson(problemJson)).toList();
        } else {
          _results = [];
          _errorMessage = 'No problems found';
        }
      } else {
        _errorMessage = 'Oops, something went wrong!';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      print('Error occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
