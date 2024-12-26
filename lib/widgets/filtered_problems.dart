import 'package:flutter/material.dart';

class Problem {
  final String title;
  final String difficulty;
  final List<String> tags;

  Problem({
    required this.title,
    required this.difficulty,
    required this.tags,
  });
}

class FilteredProblemsWidget extends StatefulWidget {
  final List<Problem> problems;

  const FilteredProblemsWidget({Key? key, required this.problems})
      : super(key: key);

  @override
  _FilteredProblemsWidgetState createState() => _FilteredProblemsWidgetState();
}

class _FilteredProblemsWidgetState extends State<FilteredProblemsWidget> {
  String _selectedDifficulty = "All";

  @override
  Widget build(BuildContext context) {
    // Filter problems based on selected difficulty
    List<Problem> filteredProblems = _selectedDifficulty == "All"
        ? widget.problems
        : widget.problems
        .where((problem) => problem.difficulty == _selectedDifficulty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Filter by Difficulty:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 16),
            DropdownButton<String>(
              value: _selectedDifficulty,
              items: ["All", "Easy", "Medium", "Hard"]
                  .map((difficulty) => DropdownMenuItem(
                value: difficulty,
                child: Text(difficulty),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 16),
        filteredProblems.isEmpty
            ? Center(
          child: Text(
            "No problems found for this difficulty.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredProblems.length,
          itemBuilder: (context, index) {
            return ProblemCard(problem: filteredProblems[index]);
          },
        ),
      ],
    );
  }
}

class ProblemCard extends StatelessWidget {
  final Problem problem;

  const ProblemCard({Key? key, required this.problem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Color.fromRGBO(57, 36, 72, 0.9),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              problem.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              'Tags: ${problem.tags.join(", ")}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Difficulty: ${problem.difficulty}',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Navigate to solve ${problem.title}!')),
                  );
                },
                child: Text(
                  'Solve Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(57, 36, 72, 1), // Text color matching the theme
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
