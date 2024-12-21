import 'package:flutter/material.dart';

class SearchResultItem extends StatelessWidget {
  final dynamic result;

  const SearchResultItem({required this.result});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.question_answer, color: Colors.blue),
      title: Text(result['title']),
      subtitle: Text(result['description'] ?? 'No description available'),
    );
  }
}
