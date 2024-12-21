import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchProvider with ChangeNotifier {
  List<dynamic> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<dynamic> get results => _results;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchResults(String query) async {
    if (query.isEmpty) return;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.leetcode.com/problems?search=$query'),
      );

      if (response.statusCode == 200) {
        _results = json.decode(response.body);
      } else {
        _errorMessage = 'Oops, something went wrong!';
      }
    } catch (e) {
      _errorMessage = 'No problems found';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
